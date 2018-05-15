module Voted
  extend ActiveSupport::Concern

  included do
   before_action :load_votable, only: %i[rating_up rating_down rating_cancel]
  end

  def rating_up
    unless current_user.author_of?(@votable)
      @votable.rating_up(current_user)
      redirect_to polymorphic_path(@votable)
    end
  end

  def rating_down
    unless current_user.author_of?(@votable)
      @votable.rating_down(current_user)
      redirect_to polymorphic_path(@votable)
    end
  end

  def rating_cancel
    @vote = @votable.votes.find_by(user_id: current_user)
    @vote.destroy if @vote
    redirect_to polymorphic_path(@votable)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end
end