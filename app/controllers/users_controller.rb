class UsersController < ApplicationController

  def new
    user = User.new
    render 'users/new', locals: { user: user }
  end

  def create
    user = User.new(users_params)
    user.password_validation_is_required = true
    if user.save
      sign_in user
      redirect_to root_url, notice: 'Signed up'
    else
      render 'users/new', locals: { user: user }
    end
  end

  private

    def users_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
