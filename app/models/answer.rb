class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def set_best_answer
    question.answers.update_all(best: false)
    update(best: true)
  end
end
