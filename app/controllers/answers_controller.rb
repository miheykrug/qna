class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :load_question, only: %i[new create]
  # before_action :load_answer, only: %i[show]

  def create
    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to @question
    else
      render "questions/show"
    end
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
