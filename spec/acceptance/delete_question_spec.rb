require 'rails_helper'

feature 'Delete question' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Author delete question' do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content 'Question successfully deleted.'
    expect(page).to_not have_content question.body
  end

  scenario 'Not author delete question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end

  scenario 'Non-authenticated user delete question' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end

end