require_relative 'acceptance_helper'

feature 'User sign up', %q{
  In order to be able to sign in
  As an user
  I want to be able to sign up
} do

  given(:registered_user) { create(:user) }
  given(:non_registered_user) { build(:user) }

  scenario 'Non-registered user try to sign up' do
    sign_up(non_registered_user)

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Registered user try to sign up' do
    sign_up(registered_user)

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to eq '/users'

  end

  scenario 'Authenticated user try to sign up' do
    sign_in(registered_user)
    visit new_user_registration_path

    expect(page).to have_content 'You are already signed in.'
    expect(current_path).to eq root_path
  end
end
