class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  include NotebooksHelper
  include SectionsHelper

  # http://stackoverflow.com/questions/2385799/how-to-redirect-to-a-404-in-rails
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def redirect_authenticated_user
    if current_user
      flash[:warning] = t('session.logged_in_already')
      redirect_to root_path
    end
  end

  def authenticate_user
    unless current_user
      flash[:warning] = t('session.not_logged_in')
      redirect_to log_in_path
    end
  end
end
