class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private

    def redirect_authenticated_user
      if current_user
        flash[:warning] = 'You are logged in already.'
        redirect_to root_path
      end
    end

    def authenticate_user
      unless current_user
        flash[:warning] = 'You are not logged in. Please log in.'
        redirect_to log_in_path
      end
    end
end
