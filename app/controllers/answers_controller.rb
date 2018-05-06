class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy best]
  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[update destroy best]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def best
    @question = @answer.question

    @answer.set_best_answer if current_user.author_of?(@question)
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
