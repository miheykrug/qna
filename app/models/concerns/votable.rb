module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating_up(user)
    vote = votes.build(rating: 1)
    vote.user = user
    vote.save
  end

  def rating_down(user)
    vote = votes.build(rating: -1)
    vote.user = user
    vote.save
  end
end