require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes) }

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

  describe '#temp_email' do
    let(:user1) { create(:user, email: '123_must@change.com') }

    it 'returns true if user email consist "must@change.com"' do
      expect(user1).to be_temp_email
    end

    it 'returns false if user email not consist "must@change.com"' do
      expect(user).to_not be_temp_email
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'vkontakte', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'create authorization for user' do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'create authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'return the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: 'new@email.com' }) }

        it 'create new user' do
          expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'return new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for new user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

      end
    end
  end
end
