module AcceptanceMacros
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  def create_question
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Question body'
    click_on 'Create'
  end

  def create_answer(question)
    visit question_path(question)
    fill_in 'Body', with: 'My Answer'
    click_on 'Give answer'
  end

  def sign_up(user)
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'
  end
end