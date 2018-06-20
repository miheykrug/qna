require_relative 'acceptance_helper'

feature 'Subscribe to the question', %q{
  In order to follow for new answers of question
  As an authenticated user
  I'd like to be able to subscribe to the question
} do
  given(:user) {  create(:user) }
  given!(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user try to subscribe to the question', js: true do
    within('.question') do
      click_on 'Subscribe to question'
      expect(page).to_not have_button 'Subscribe to question'
      expect(page).to have_button 'Unsubscribe to question'
    end
  end

  scenario 'Authenticated user try to Unsubscribe to the question', js: true do
    within('.question') do
      click_on 'Subscribe to question'
      click_on 'Unsubscribe to question'
      expect(page).to have_button 'Subscribe to question'
      expect(page).to_not have_button 'Unsubscribe to question'
    end
  end
end