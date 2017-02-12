class NotebooksController < ApplicationController
  before_action :authenticate_user

  def index
    notebooks = current_user.notebooks
    render 'notebooks/index', locals: { notebooks: notebooks }
  end
end
