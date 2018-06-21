class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :notify_subscribers

  def set_best_answer
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  private

  def notify_subscribers
    NewAnswerNotifyJob.perform_later(self)
  end
end
