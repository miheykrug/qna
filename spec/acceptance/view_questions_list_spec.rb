require 'rails_helper'

feature 'View the questions list' do
  given!(:questions) {create_list(:question, 3)}
  scenario 'Any user can view the questions list' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end