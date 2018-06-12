class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: %i[show]

  authorize_resource

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, serializer: QuestionShowSerializer
  end

  def create
    current_user.questions.create(question_params)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
