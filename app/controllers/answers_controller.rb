class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[destroy]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
        format.js
        format.html { redirect_to @question }
      else
        format.js
        format.html { render 'questions/show' }
      end
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
