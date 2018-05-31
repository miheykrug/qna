require_relative 'acceptance_helper'

feature 'Delete question file', %q{
  In order to remove unnecessary attachment
  As an question's author
  I'd  like to be able to delete file
} do

  given(:author) {  create(:user) }
  given(:user) {  create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:file) { create(:attachment, attachable: question)}

  describe 'Authenticate user' do
    scenario 'try delete file of his question', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'Delete file'
      page.driver.accept_js_confirms!

      expect(page).to_not have_link 'rails_helper.rb'
    end
    scenario 'try delete file of another user question' do
      sign_in(user)
      visit question_path(question)
      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario 'Non-authenticate user try delete file' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete file'
  end
end
