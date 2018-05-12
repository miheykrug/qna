require_relative 'acceptance_helper'

feature 'Vote for the question', %q{
  In order to express favor to author of question
  As an authenticated user
  I'd like to be able to vote for the question
} do

  given(:user) {  create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user try to vote for the question' do
    within('.question') do
      click_on '+'
      expect(page).to have_content '1'
    end
  end

  scenario 'Authenticated user try to vote for the question two times' do
    within('.question') do
      click_on '+'
      click_on '+'
      save_and_open_page
      expect(page).to have_content '1'
    end
  end
  scenario 'Authenticated user try to cancel his vote'
  scenario 'Authenticated user try to vote again after canceling'
  scenario 'Author of question try to vote for his question'
end