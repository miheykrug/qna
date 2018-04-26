require 'rails_helper'

feature 'Create answer', %q{
  In order to offer a solution question
  As an authenticated user
  I want to be able to give an answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  scenario 'Authenticated user create answer' do
    sign_in(user)

    create_answer(question)
    expect(page).to have_content 'My Answer'
  end

  scenario 'Non-authenticated user create answer' do
    create_answer(question)
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
