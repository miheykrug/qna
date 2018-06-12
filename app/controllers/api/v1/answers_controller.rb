class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %i[index]
  before_action :load_answer, only: %i[show]

  def index
    respond_with @question.answers
  end

  def show
    respond_with @answer, serializer: AnswerShowSerializer
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
