require_relative 'acceptance_helper'

feature 'Add comment to answer', %q{
  In order to express my opinion on the answer
  As an authenticate user
  I'd  like to be able to comment on the answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticate user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'see link to Add comment' do
      within('.answers') do
        expect(page).to have_link 'Add comment'
      end
    end

    describe 'try to add comment to answer' do
      scenario 'with valid attributes', js: true do
        within('.answers') do
          click_on 'Add comment'
          fill_in 'New comment', with: 'My answer comment'
          click_on 'Create Comment'
          expect(page).to have_content 'My answer comment'
        end
      end

      scenario 'with invalid attributes', js: true do
        within('.answers') do
          click_on 'Add comment'
          fill_in 'New comment', with: nil
          click_on 'Create Comment'
          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  end
end
