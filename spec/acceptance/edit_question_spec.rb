require_relative 'acceptance_helper'

feature 'Question edit', %q{
  In order to fix mistake
  As an author of question
  I'd like to be able to edit my question
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)
    expect(page).to_not have_link  'Edit'
  end

  describe 'Authenticated user' do
    scenario 'sees link to Edit' do
      sign_in author
      visit question_path(question)

      expect(page).to have_link 'Edit'
    end

    describe 'try to edit his question' do
      before do
        sign_in author
        visit question_path(question)
      end
      scenario 'with valid attributes', js: true do
        within('.question') do
          click_on 'Edit'
          fill_in 'Title', with: 'edited title'
          fill_in 'Body', with: 'edited question'
          click_on 'Save'
        end
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited question'
      end

      scenario 'with invalid attributes', js: true do

        within('.question') do
          click_on 'Edit'
          fill_in 'Title', with: nil
          fill_in 'Body', with: nil
          click_on 'Save'
        end
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end

    end

    scenario "try to edit other user's question" do
      sign_in user
      visit question_path(question)

      expect(page).to_not have_link  'Edit'
    end
  end
end
