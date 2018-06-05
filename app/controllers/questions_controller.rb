class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: %i[new create edit update destroy
                                              rating_up rating_down rating_cancel]
  before_action :load_question, only: %i[show edit update destroy]

  before_action :new_answer, only: :show

  after_action :publish_question, only: %i[create]

  respond_to :html, :js

  authorize_resource

  def index
    respond_with @questions = Question.all
  end

  def show
    gon.current_user = current_user
    respond_with @question
  end

  def new
    @question = current_user.questions.build
    respond_with @question
  end

  def update
    @question.update(question_params) #if current_user.author_of?(@question)
    respond_with @question
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def destroy
    flash[:notice] = 'Question successfully deleted.'
    respond_with @question.destroy #if current_user.author_of?(@question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def new_answer
    @answer = Answer.new
  end
end
