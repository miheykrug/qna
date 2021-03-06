class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :subscriptions
  has_many :subscribers, class_name:'User', through: :subscriptions, source: :user, dependent: :destroy

  belongs_to :user

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :subscribe_author

  def subscription(user)
    subscriptions.find_by(user: user)
  end

  private

  def subscribe_author
    subscribers.push(self.user)
  end
end
