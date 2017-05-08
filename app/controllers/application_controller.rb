class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  include NotebooksHelper
  include SectionsHelper

  private

  def redirect_authenticated_user
    if current_user
      flash[:warning] = t('logged_in_already')
      redirect_to root_path
    end
  end

  def authenticate_user
    unless current_user
      flash[:warning] = t('not_logged_in')
      redirect_to log_in_path
    end
  end
end
