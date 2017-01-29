class PasswordResetsController < ApplicationController
  before_action :redirect_authenticated_user

  def new
    render 'password_resets/new'
  end

  def create
    if PasswordResetService.new.send_instructions(params[:password_reset][:email])
      redirect_to root_path, notice: 'Email was sent with password reset instructions.'
    else
      flash.now[:error] = 'Email format is invalid. Please, enter valid email.'
      render 'password_resets/new', status: 400
    end
  end

  def edit
    render 'password_resets/edit', locals: { user: user_by_token }
  end

  def update
    if PasswordResetService.new.update_password(user_by_token, params[:user])
      redirect_to root_path, notice: 'Password has been reset.'
    else
      flash.now[:error] = 'The password reset failed. Please correct the fields.'
      render 'password_resets/edit', locals: { user: user_by_token }, status: 400
    end
  rescue PasswordResetService::PasswordResetExpired
    flash[:warning] = 'Password reset has expired.'
    redirect_to new_password_reset_path
  end

  private

    def user_by_token
      @user ||= User.find_by!(password_reset_token: params[:id])
    end
end
