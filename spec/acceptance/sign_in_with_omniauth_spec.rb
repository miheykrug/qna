require_relative 'acceptance_helper'

feature 'Authorization from providers', %{
  In order to work with Questions and Answers
  As a user
  I want to registration using my other social network accounts
} do


  let(:user) { create(:user, email: 'email@temp.email') }
  let(:email) { 'new@email.com' }

  describe 'Twitter' do
    scenario 'User is authorized for the first time', js: true do
      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Add email'

      fill_in 'Email', with: email
      click_on 'Continue'

      page.should have_content("Log out")
    end

    scenario 'User is already authorized', js: true do
      auth = mock_auth_hash(:twitter, user.email)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content('Successfully authenticated from Twitter account.')
    end
  end

  describe 'Vkontakte' do
    scenario 'User try to authorized', js: true do
      visit new_user_session_path
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content('Successfully authenticated from Vkontakte account.')

    end

    scenario 'User is already authorized', js: true do
      auth = mock_auth_hash(:vkontakte, user.email)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content('Successfully authenticated from Vkontakte account.')
    end
  end
end