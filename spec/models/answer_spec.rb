require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:attachments).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  describe '#set_best_question' do
    let(:question) { create(:question) }
    let!(:old_best_answer) { create(:answer, question: question, best: true) }
    let(:new_best_answer) { create(:answer, question: question) }

    before { new_best_answer.set_best_answer }

    it 'set new best answer of question' do
      new_best_answer.reload
      expect(new_best_answer).to be_best
    end

    it 'set old best answer best attribute to false' do
      old_best_answer.reload
      expect(old_best_answer).to_not be_best
    end
  end

  describe '#notify_subscribers' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    subject { build(:answer, question: question, user: user) }

    it 'should send notify_subscribers method after create question' do
      expect(subject).to receive(:notify_subscribers)
      subject.save!
    end

    it 'should not send notify_subscribers method after create question' do
      subject.save!
      expect(subject).to_not receive(:notify_subscribers)
      subject.update(body: '123')
    end
  end

  it_behaves_like 'votable'
  it_behaves_like 'commentable'
end
