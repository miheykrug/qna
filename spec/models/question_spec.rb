require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:subscribers).dependent(:destroy) }

  it { should belong_to(:user) }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  describe '#subscribe_author' do
    let(:user) { create(:user) }
    subject { build(:question, user: user) }

    it 'should send subscribe_author method after create question' do
      expect(subject).to receive(:subscribe_author)
      subject.save!
    end

    it 'should not send subscribe_author method after create question' do
      subject.save!
      expect(subject).to_not receive(:subscribe_author)
      subject.update(body: '123')
    end

    it 'should subscribe author to question' do
      expect{ subject.save! }.to change(subject.subscribers, :count).by(1)
    end
  end
end
