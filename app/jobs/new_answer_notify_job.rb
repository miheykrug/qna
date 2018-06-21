class NewAnswerNotifyJob < ApplicationJob
  queue_as :default

  def perform(object)
    users = object.question.subscribers
    users.find_each do |user|
      AnswerMailer.new_notify(user, object.question).deliver_later
    end
  end
end
