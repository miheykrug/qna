class AnswerMailer < ApplicationMailer

  def new_notify(user, question)
    @question = question

    mail to: user.email
  end
end
