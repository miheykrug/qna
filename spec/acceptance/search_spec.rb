require_relative 'acceptance_helper'

feature 'Search in questions, answers, comments and users' do
  given(:user) { create(:user) }

  scenario 'try to search user by email', js: true do
    ThinkingSphinx::Test.run do
      visit queries_path
      fill_in 'Query', with: user.email
      click_button 'Search'

      expect(page).to have_content user.email
      expect(page).to have_content user.id
    end
  end
end
