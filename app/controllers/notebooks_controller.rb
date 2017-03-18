class NotebooksController < ApplicationController
  before_action :authenticate_user

  # add_breadcrumb 'Notebooks', :notebooks_path

  def index
    notebooks = current_user.notebooks.order(created_at: :desc)
    render 'notebooks/index', locals: { notebooks: notebooks }
  end

  def new
    notebook = current_user.notebooks.build
    render 'notebooks/new', locals: { notebook: notebook }
  end

  def create
    notebook = current_user.notebooks.build notebook_params
    if notebook.save
      flash[:success] = "#{notebook.name} successfully created."
      redirect_to notebook_sections_path(notebook)
    else
      flash.now[:error] = 'We can not create a notebook. Please correct the fields.'
      render 'notebooks/new', locals: { notebook: notebook }, status: 422
    end
  end

  private

  def notebook_params
    params.require(:notebook).permit(:name)
  end

  def notebooks_path
    notebooks_path
  end
end
