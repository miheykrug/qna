require_relative 'acceptance_helper'

feature 'Delete answer' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Author delete answer', js: true do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete answer'
    page.driver.accept_js_confirms!
    expect(page).to_not have_content answer.body
  end

  scenario 'Not author delete answer' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Non-authenticated user delete answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete answer'
  end

end