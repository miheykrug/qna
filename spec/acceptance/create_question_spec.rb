require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user create question with valid attributes' do
    sign_in(user)
    create_question

    question = Question.last
    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Authenticated user create question with invalid attributes' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: nil
    fill_in 'Body', with: nil
    click_on 'Create'
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end


  scenario 'Non-authenticated user create question' do
    visit questions_path
    click_on 'Ask question'

    # save_and_open_page
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
