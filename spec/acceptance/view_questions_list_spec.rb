require 'rails_helper'

feature 'View the questions list' do

  scenario 'Any user can view the questions list' do
    visit questions_path
    expect(page).to have_content 'Questions list'
  end
end