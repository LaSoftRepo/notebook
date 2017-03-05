class SessionsController < ApplicationController
  before_action :authenticate_user, only: :destroy
  before_action :redirect_authenticated_user, only: [:new, :create]

  def new
    render 'sessions/new'
  end

  def create
    user = User.authenticate(params[:log_in][:email], params[:log_in][:password])
    if user
      log_in(user, params[:log_in][:remember_me] == '1')
      redirect_to notebooks_path, notice: 'Logged in!'
    else
      flash.now[:error] = 'Invalid email or password.'
      render 'sessions/new', status: 422
    end
  end

  def destroy
    log_out
    redirect_to root_path, notice: 'Logged out!'
  end
end
