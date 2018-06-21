class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create destroy]

  authorize_resource

  def create
    @question.subscribers.push(current_user)
  end

  def destroy
    @subscribe = @question.subscription(current_user)
    @subscribe.destroy if @subscribe
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

end
