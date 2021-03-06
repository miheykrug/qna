class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def vkontakte
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    end

  end

  def twitter
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      if @user.temp_email?
        sign_in @user
        redirect_to users_edit_email_path
      else
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
      end
    end
  end
end
