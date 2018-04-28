require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  let(:user) { create(:user) }

  describe 'check if the user is the author of the resource' do
    describe 'user is author of question' do
      it 'should be true' do
        question = create(:question, user: user)
        expect(user.author_of?(question)).to be true
      end
    end

    describe 'user is not author of question' do
      it 'should be false' do
        question = create(:question)
        expect(user.author_of?(question)).to be false
      end
    end
  end
end
