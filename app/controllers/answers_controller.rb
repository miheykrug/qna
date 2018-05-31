class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: %i[create update destroy best
                                              rating_up rating_down rating_cancel]
  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[update destroy best]

  after_action :publish_answer, only: %i[create]

  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy) if current_user.author_of?(@answer)
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

  def publish_answer
    return if @answer.errors.any?
    attachments = @answer.attachments.map do |a|
      { id: a.id, file_url: a.file.url, file_name: a.file.filename }
    end

    ActionCable.server.broadcast(
      "question_#{@question.id}",
      { answer: @answer, attachments: attachments, question: @question, rating: @answer.rating_sum }
    )
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

end
