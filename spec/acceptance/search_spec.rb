require_relative 'acceptance_helper'

feature 'Search in questions, answers, comments and users' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  # scenario 'try to search user by email', js: true, sphinx: true do
  #     visit queries_path
  #     fill_in 'Query', with: user.email
  #     click_button 'Search'
  #
  #     expect(page).to have_content user.email
  #     expect(page).to have_content user.id
  # end

  scenario 'try to search question by title', js: true, sphinx: true do
      visit queries_path
      fill_in 'Query', with: question.title
      click_button 'Search'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
  end
end
