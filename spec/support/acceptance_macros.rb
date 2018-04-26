module AcceptanceMacros
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def create_answer(question)
    visit question_path(question)
    fill_in 'Body', with: 'My Answer'
    click_on 'Give answer'
  end
end