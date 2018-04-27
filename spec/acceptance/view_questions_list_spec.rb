require 'rails_helper'

feature 'View the questions list' do
  given!(:questions) {create_list(:question, 2)}
  scenario 'Any user can view the questions list' do
    visit questions_path
    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[0].body
    expect(page).to have_content questions[1].title
    expect(page).to have_content questions[1].body
  end
end