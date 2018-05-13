class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy rating_up rating_down]
  before_action :load_question, only: %i[show edit update destroy rating_up rating_down rating_cancel]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer = Answer.new
    @answer.attachments.build
  end

  def new
    @question = current_user.questions.build
    @question.attachments.build
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Question successfully deleted.'
      redirect_to questions_path
    else
      flash[:alert] = 'Only author can delete this question!'
      redirect_to question_path(@question)
    end
  end

  def rating_up
    unless current_user.author_of?(@question)
      @vote = @question.votes.build(rating: 1)
      @vote.user = current_user
      @vote.save
      redirect_to question_path(@question)
    end
  end

  def rating_down
    unless current_user.author_of?(@question)
      @vote = @question.votes.build(rating: -1)
      @vote.user = current_user
      @vote.save
      redirect_to question_path(@question)
    end
  end

  def rating_cancel
    @vote = @question.votes.find_by(user_id: current_user)
    @vote.destroy if @vote
    redirect_to question_path(@question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
