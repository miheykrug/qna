require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

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
end
