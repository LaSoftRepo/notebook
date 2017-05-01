class NotebooksController < ApplicationController
  include Breadcrumbs::Notebook
  before_action :authenticate_user
  before_action :find_notebook, only: [:edit, :update]

  def index
    @notebooks = current_user.notebooks.order(created_at: :desc)
    render 'notebooks/index'
  end

  def new
    @notebook = current_user.notebooks.build
    render 'notebooks/new'
  end

  def create
    @notebook = current_user.notebooks.build notebook_params
    if @notebook.save
      flash[:success] = "#{@notebook.name} successfully created."
      redirect_to notebook_sections_path(@notebook)
    else
      flash.now[:error] = 'We can not create a notebook. Please correct the fields.'
      render 'notebooks/new', status: 422
    end
  end

  def edit
    render 'notebooks/edit'
  end

  def update
    if @notebook.update_attributes(notebook_params)
      flash[:success] = "#{@notebook.name} successfully updated."
      redirect_to notebook_sections_path(@notebook)
    else
      flash.now[:error] = 'We can not update a notebook. Please correct the fields.'
      render 'notebooks/edit', status: 422
    end
  end

  private

  def find_notebook
    @notebook ||= current_user.notebooks.find params[:id]
  end

  def notebook_params
    params.require(:notebook).permit(:name)
  end
end
