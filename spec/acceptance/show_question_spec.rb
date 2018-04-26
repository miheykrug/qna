require 'rails_helper'

feature 'Show question and its answers' do
  given(:question) { create(:question) }

  scenario 'Any user can view question and its answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content 'Answers'
  end
end