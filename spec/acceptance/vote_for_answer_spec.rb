require_relative 'acceptance_helper'

feature 'Vote for the answer', %q{
  In order to express favor to author of answer
  As an authenticated user
  I'd like to be able to vote for the answer
} do

  given(:user) {  create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:user_answer) { create(:answer, question: question, user: user) }


  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user try to vote for the answer', js: true do
    within(".vote.#{answer.class}-#{answer.id}") do
      click_on '+'
      expect(page).to have_content '1'
      expect(page).to have_content 'cancel vote'
    end
  end

  scenario 'Authenticated user try to vote for the answer two times', js: true do
    within(".vote.#{answer.class}-#{answer.id}") do
      click_on '+'
      click_on '+'
      expect(page).to have_content '1'
    end
  end
  scenario 'Authenticated user try to cancel his vote', js: true do
    within(".vote.#{answer.class}-#{answer.id}") do
      click_on '+'
      click_on 'cancel vote'
      expect(page).to have_content '0'
      expect(page).to_not have_content 'cancel vote'
    end
  end
  scenario 'Authenticated user try to vote again after canceling', js: true do
    within(".vote.#{answer.class}-#{answer.id}") do
      click_on '+'
      click_on 'cancel vote'
      click_on '-'
      expect(page).to have_content '-1'
    end

  end

  scenario 'Author of answer try to vote for his answer' do
    within(".vote.#{user_answer.class}-#{user_answer.id}") do
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
    end
  end
end