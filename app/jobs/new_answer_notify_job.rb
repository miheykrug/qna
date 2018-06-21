class NewAnswerNotifyJob < ApplicationJob
  queue_as :default

  def perform(object)
    users = object.question.subscribers
    users.each do |user|
      AnswerMailer.new_notify(user, object.question).deliver_now
    end
  end
end
