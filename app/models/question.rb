class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :answer, optional: true

  validates :title, :body, presence: true
end
