module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: %i[rating_up rating_down rating_cancel]
  end

  def rating_up
    unless current_user&.author_of?(@votable)
      @votable.rating_up(current_user)
      render_voted_json
    end
  end

  def rating_down
    unless current_user&.author_of?(@votable)
      @votable.rating_down(current_user)
      render_voted_json
    end
  end

  def rating_cancel
    @vote = @votable.votes.find_by(user_id: current_user)
    @vote.destroy if @vote
    render_voted_json
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end

  def render_voted_json
    render json: { rating: @votable.rating_sum, klass: @votable.class.to_s, id: @votable.id }
  end
end