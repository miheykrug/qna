class DailyMailer < ApplicationMailer

  def digest(user)
    @day_questions = Question.where(created_at: Date.today.all_day)

    mail to: user.email
  end
end
