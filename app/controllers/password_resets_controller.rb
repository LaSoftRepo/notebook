class PasswordResetsController < ApplicationController
  before_action :redirect_authenticated_user
  before_action :find_user_by_token, only: [:edit, :update]
  before_action :redirect_if_password_reset_has_expired, only: [:edit, :update]

  def new
    render 'password_resets/new'
  end

  def create
    if params[:password_reset][:email].blank?
      flash.now[:error] = 'Please, enter your email.'
      render 'password_resets/new'
    else
      user = User.find_by(email: params[:password_reset][:email])
      user.send_password_reset_instructions if user
      redirect_to root_url, notice: 'Email was sent with password reset instructions.'
    end
  end

  def edit
    render 'password_resets/edit', locals: { user: @user }
  end

  def update
    @user.password_validation_is_required = true
    if @user.update_attributes(user_params)
      redirect_to root_url, notice: 'Password has been reset.'
    else
      flash.now[:error] = 'The password reset failed. Please correct the fields.'
      render 'password_resets/edit', locals: { user: @user }
    end
  end

  private

    def find_user_by_token
      @user = User.find_by!(password_reset_token: params[:id])
    end

    def redirect_if_password_reset_has_expired
      if @user.password_reset_sent_at < 1.hour.ago
        flash[:warning] = 'Password reset has expired.'
        redirect_to new_password_reset_path
      end
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
