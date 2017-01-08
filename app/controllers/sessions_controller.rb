class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.authenticate(params[:log_in][:email], params[:log_in][:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Logged in!'
    else
      flash.now[:error] = 'Invalid email or password'
      render 'sessions/new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end
