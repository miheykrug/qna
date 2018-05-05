require_relative 'acceptance_helper'

feature 'Set the best question', %q{
  In order to identify answer which solves the issue
  As an author of question
  I want to be able to set the best question
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given!(:best_answer) { create(:answer, question: question) }

  describe 'Author of question' do
    scenario 'sees link to Best' do
      sign_in author
      visit question_path(question)

      expect(page).to have_link 'Best'
    end

    scenario 'try to set the best question', js: true do
      sign_in author
      visit question_path(question)
      within("#answer-#{best_answer.id}") do
        click_on 'Best'
      end
      within('.answers') do
        expect(page).to have_css('.best-answer')
        expect(first('[id^="answer-"]')).to have_content best_answer.body
      end
    end
  end
  scenario 'Authenticated user try to set the best question' do
    sign_in user
    visit question_path(question)
    expect(page).to_not have_link  'Best'
  end

  scenario 'Non-authenticated user try to set the best question' do
    visit question_path(question)
    expect(page).to_not have_link  'Best'
  end
end
