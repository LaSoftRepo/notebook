class SectionsController < ApplicationController
  include Breadcrumbs::Section
  before_action :authenticate_user
  before_action :verify_notebook
  before_action :find_section, only: [:edit, :update]

  def index
    @sections = current_notebook.sections.order(created_at: :desc)
    render 'sections/index'
  end

  def new
    @section = current_notebook.sections.build
    render 'sections/new'
  end

  def create
    @section = current_notebook.sections.build(section_params)
    if @section.save
      flash[:success] = t('created', name: @section.name)
      redirect_to notebook_section_notices_path(section_id: @section.id)
    else
      flash.now[:error] = t('section.not_created')
      render 'sections/new', status: 422
    end
  end

  def edit
    render 'sections/edit'
  end

  def update
    if @section.update_attributes(section_params)
      flash[:success] = t('updated', name: @section.name)
      redirect_to notebook_section_notices_path(section_id: @section.id)
    else
      flash.now[:error] = t('section.not_updated')
      render 'sections/edit', status: 422
    end
  end

  private

  def find_section
    @section ||= current_notebook.find_section params[:id]
  end

  def section_params
    params.require(:section).permit(:name, :description)
  end
end
