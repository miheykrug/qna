require "rails_helper"

RSpec.describe AnswerMailer, type: :mailer do
  describe "new_notify" do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let(:mail) { AnswerMailer.new_notify(user, question) }

    it "renders the headers" do
      expect(mail.subject).to eq("New notify")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["mail@qna.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(question.title)
    end
  end

end
