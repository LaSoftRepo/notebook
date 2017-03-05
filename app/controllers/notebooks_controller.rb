class NotebooksController < ApplicationController
  before_action :authenticate_user

  def index
    notebooks = current_user.notebooks.order(created_at: :desc)
    render 'notebooks/index', locals: { notebooks: notebooks }
  end

  def create
    notebook = current_user.notebooks.build notebooks_params
    if notebook.save
      flash[:notice] = "#{notebook.name} successfully created."
      redirect_to notebook_sections_path(notebook)
    else
      flash[:error] = notebook.pretty_errors
      redirect_to notebooks_path
    end
  end

  private

    def notebooks_params
      params.require(:notebook).permit(:name)
    end
end
