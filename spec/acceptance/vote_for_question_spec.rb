require_relative 'acceptance_helper'

feature 'Vote for the question', %q{
  In order to express favor to author of question
  As an authenticated user
  I'd like to be able to vote for the question
} do

  given(:user) {  create(:user) }
  given(:question) { create(:question) }
  given(:user_question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user try to vote for the question', js: true do
    within('.question .vote') do
      click_on '+'
      expect(page).to have_content '1'
      expect(page).to have_content 'cancel vote'
    end
  end

  scenario 'Authenticated user try to vote for the question two times', js: true do
    within('.question .vote') do
      click_on '+'
      click_on '+'
      expect(page).to have_content '1'
    end
  end
  scenario 'Authenticated user try to cancel his vote', js: true do
    within('.question .vote') do
      click_on '+'
      click_on 'cancel vote'
      expect(page).to have_content '0'
      expect(page).to_not have_content 'cancel vote'
    end
  end
  scenario 'Authenticated user try to vote again after canceling', js: true do
    within('.question .vote') do
      click_on '+'
      click_on 'cancel vote'
      click_on '-'
      expect(page).to have_content '-1'
    end

  end

  scenario 'Author of question try to vote for his question' do
    visit question_path(user_question)
    expect(page).to_not have_link '+'
    expect(page).to_not have_link '-'
  end
end