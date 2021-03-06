require_relative 'acceptance_helper'

feature 'Create answer', %q{
  In order to offer a solution question
  As an authenticated user
  I want to be able to give an answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  scenario 'Authenticated user create answer with valid attributes', js: true do
    sign_in(user)

    create_answer(question)
    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'My Answer'
    end
  end

  scenario 'Authenticated user create answer with invalid attributes', js: true do
    sign_in(user)
    visit question_path(question)
    within('.answer-form') do
      fill_in 'Body', with: nil
      click_on 'Give answer'
    end
    expect(page).to have_content "Body can't be blank"
  end


  scenario 'Non-authenticated user create answer', js: true do
    create_answer(question)
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context 'multiple sessions' do
    scenario "answer appear on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        create_answer(question)
        within('.answers') do
          expect(page).to have_content 'My Answer'
        end
      end

      Capybara.using_session('guest') do
        within('.answers') do
          expect(page).to have_content 'My Answer'
        end
      end
    end
  end

end
