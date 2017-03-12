class UsersController < ApplicationController
  before_action :redirect_authenticated_user, only: [:new, :create]

  def new
    user = User.new
    render 'users/new', locals: { user: user }
  end

  def create
    user = recorder.create(user_params)
    if user.valid?
      log_in user
      redirect_to root_path, notice: 'Signed up!'
    else
      flash.now[:error] = 'The sign up failed. Please correct the fields.'
      render 'users/new', locals: { user: user }, status: 422
    end
  end

  private

    def recorder(user = nil)
      UserRecorder.new(user: user)
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
