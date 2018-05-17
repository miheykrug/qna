module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating_up(user)
    votes.create!(user: user, rating: 1) unless vote_of?(user)
  end

  def rating_down(user)
    votes.create!(user: user, rating: -1) unless vote_of?(user)
  end

  def vote_of?(user)
    votes.exists?(user: user)
  end

  def rating_sum
    votes.sum(:rating)
  end
end