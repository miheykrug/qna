class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %i[index create]
  before_action :load_answer, only: %i[show]

  authorize_resource

  def index
    respond_with @question.answers
  end

  def show
    respond_with @answer, serializer: AnswerShowSerializer
  end

  def create
    @question.answers.create(answer_params.merge(user: current_user))
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
