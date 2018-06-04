class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit_email update_email]
  before_action :email_verify, only: %i[edit_email update_email]

  def edit_email

  end

  def update_email
    if current_user.update_attribute('email', params[:user][:email])
      redirect_to root_path
    else
      render :edit_email
    end
  end

  private

  def email_verify
    unless current_user.temp_email?
      redirect_to root_path, notice: 'You do not need to change email'
    end
  end
end
