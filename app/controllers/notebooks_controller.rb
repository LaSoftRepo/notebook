class NotebooksController < ApplicationController
  before_action :authenticate_user

  def index
    notebooks = current_user.notebooks
    render 'notebooks/index', locals: { notebooks: notebooks }
  end

  def show
    notebook = current_user.notebooks.find params[:id]
    render 'notebooks/show', locals: { notebook: notebook }
  end
end
