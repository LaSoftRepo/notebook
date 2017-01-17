class SessionsController < ApplicationController
  before_action :redirect_signed_in_user, only: [:new, :create]

  def new
    render 'sessions/new'
  end

  def create
    user = User.authenticate(params[:log_in][:email], params[:log_in][:password])
    if user
      sign_in(user, params[:log_in][:remember_me] == '1')
      redirect_to root_url, notice: 'Logged in!'
    else
      flash.now[:error] = 'Invalid email or password.'
      render 'sessions/new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url, notice: 'Logged out!'
  end
end
