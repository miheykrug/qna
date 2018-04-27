require 'rails_helper'

feature 'Create answer', %q{
  In order to offer a solution question
  As an authenticated user
  I want to be able to give an answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  scenario 'Authenticated user create answer with valid attributes' do
    sign_in(user)

    create_answer(question)
    expect(page).to have_content 'My Answer'
  end

  scenario 'Authenticated user create answer with invalid attributes' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: nil
    click_on 'Give answer'
    expect(page).to have_content '1 errors detected:'
  end


  scenario 'Non-authenticated user create answer' do
    create_answer(question)
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
