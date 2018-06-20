# Preview all emails at http://localhost:3000/rails/mailers/answer_mailer
class AnswerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/answer_mailer/new_notify
  def new_notify
    user = User.first
    question = Question.first
    AnswerMailer.new_notify(user, question)
  end

end
