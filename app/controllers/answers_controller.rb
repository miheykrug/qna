class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[destroy]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question
    else
      render "questions/show"
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer successfully deleted.'
    else
      flash[:alert] = 'Only author can delete this answer!'
    end
    redirect_to question_path(@answer.question)
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
