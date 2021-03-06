require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd  like to be able to attach files
} do

  given(:user) {  create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file to answer', js: true do
    within('.answer-form') do
      fill_in 'Body', with: 'My Answer'
    end
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Give answer'

    within('.answers') do
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end

  scenario 'User adds more than one file', js: true do
    within('.answer-form') do
      fill_in 'Body', with: 'My Answer'
      click_on 'add file'
    end

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/rails_helper.rb")
    inputs[1].set("#{Rails.root}/spec/spec_helper.rb")

    click_on 'Give answer'

    within('.answers') do
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    end
  end
end
