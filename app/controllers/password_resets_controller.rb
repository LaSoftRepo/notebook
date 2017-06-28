class PasswordResetsController < ApplicationController
  before_action :redirect_authenticated_user
  before_action :user_by_token, only: [:edit, :update]

  def new
    @error = t('password_reset.expired') if params[:expired].present?
    render 'password_resets/new'
  end

  def create
    if service.send_instructions(params[:password_reset][:email])
      redirect_to root_path, notice: t('password_reset.email_was_sent')
    else
      @error = t('password_reset.invalid_email')
      render 'password_resets/new', status: 422
    end
  end

  def edit
    render 'password_resets/edit'
  end

  def update
    if service.update_password(@user, password_reset_params)
      redirect_to root_path, notice: t('password_reset.password_has_been_reset')
    else
      render 'password_resets/edit', status: 422
    end
  rescue PasswordResetService::PasswordResetExpired
    redirect_to new_password_reset_path(expired: true)
  end

  private

  def service
    PasswordResetService.new
  end

  def user_by_token
    @user ||= User.find_by!(password_reset_token: params[:id])
  end

  def password_reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
