module ControllerMacros
  def sign_in_user
    before do
      @user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
    @user
  end

  def sign_in_user_with_temp_email
    before do
      @user = create(:user, email: '123_must@change.com')
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
    @user
  end
end
