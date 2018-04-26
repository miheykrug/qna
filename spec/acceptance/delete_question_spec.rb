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
  end

  scenario 'Not author delete question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content 'Only author can delete this question!'
  end
end