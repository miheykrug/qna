require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  let(:user) { create(:user) }

  describe '#author_of?(resource)' do
    it 'returns true if the user is an author of resource' do
      question = create(:question, user: user)
      expect(user).to be_author_of(question)
    end

    it 'returns false if the user is not an author of resource' do
      question = create(:question)
      expect(user).to_not be_author_of(question)
    end
  end
end
