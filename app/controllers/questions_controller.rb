class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :load_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = current_user.questions.build
  end

  def edit
  end

  def update
    return unless current_user.author_of?(@question)
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
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

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
