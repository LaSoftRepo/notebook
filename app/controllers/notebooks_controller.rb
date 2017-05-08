class NotebooksController < ApplicationController
  include Breadcrumbs::Notebook
  before_action :authenticate_user
  before_action :find_notebook, only: [:edit, :update, :destroy]

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
      flash[:success] = t('created', name: @notebook.name)
      redirect_to notebook_sections_path(@notebook)
    else
      flash.now[:error] = t('not_created', name: 'notebook')
      render 'notebooks/new', status: 422
    end
  end

  def edit
    render 'notebooks/edit'
  end

  def update
    if @notebook.update_attributes(notebook_params)
      flash[:success] = t('updated', name: @notebook.name)
      redirect_to notebook_sections_path(@notebook)
    else
      flash.now[:error] = t('not_updated', name: 'notebook')
      render 'notebooks/edit', status: 422
    end
  end

  def destroy
    @notebook.destroy
    flash[:success] = t('deleted', name: @notebook.name)
    redirect_to notebooks_path
  end

  private

  def find_notebook
    @notebook ||= current_user.notebooks.find params[:id]
  end

  def notebook_params
    params.require(:notebook).permit(:name)
  end
end
