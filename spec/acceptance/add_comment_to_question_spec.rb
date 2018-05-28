require_relative 'acceptance_helper'

feature 'Add comment to question', %q{
  In order to express my opinion on the question
  As an authenticate user
  I'd  like to be able to comment on the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticate user' do
    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'see link to Add comment' do
      expect(page).to have_link 'Add comment'
    end

    describe 'try to add comment to question' do
      scenario 'with valid attributes', js: true do
        within('.question') do
          click_on 'Add comment'
          fill_in 'New comment', with: 'My comment'
          click_on 'Create Comment'
        end
        expect(page).to have_content 'My comment'
      end

      scenario 'with invalid attributes', js: true do
        within('.question') do
          click_on 'Add comment'
          fill_in 'New comment', with: nil
          click_on 'Create Comment'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end
  end
end
