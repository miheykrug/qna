require 'rails_helper'

RSpec.describe NewAnswerNotifyJob, type: :job do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, question: question) }
  let!(:subscription) { create(:subscription, user: user, question: question) }
  let(:users) { [user, author] }

  it 'should send daily digest to question subscribers' do
    users.each { |user| expect(AnswerMailer).to receive(:new_notify).with(user, question).and_call_original }
    NewAnswerNotifyJob.perform_now(answer)
  end
end
