class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private

    def redirect_signed_in_user
      if current_user
        flash[:warning] = 'You are signed in already.'
        redirect_to root_path
      end
    end
end
