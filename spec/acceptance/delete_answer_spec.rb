require 'rails_helper'

feature 'Delete answer' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: author) }

  before do
    question
    answer
  end

  scenario 'Author delete answer' do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete answer'
    expect(page).to have_content 'Answer successfully deleted.'
  end

  scenario 'Not author delete answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'
    expect(page).to have_content 'Only author can delete this answer!'
  end
end