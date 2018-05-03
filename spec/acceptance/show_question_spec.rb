require_relative 'acceptance_helper'

feature 'Show question and its answers' do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  scenario 'Any user can view question and its answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end