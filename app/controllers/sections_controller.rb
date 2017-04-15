class SectionsController < ApplicationController
  include Breadcrumbs::Section
  before_action :authenticate_user

  def index
    sections = current_notebook.sections
    render 'sections/index', locals: { sections: sections }
  end

  def show
    # current_section...
  end

  def new
    section = current_notebook.sections.build
    render 'sections/new', locals: { section: section }
  end

  def create
    section = current_notebook.sections.build(section_params)
    if section.save
      flash[:success] = "#{section.name} successfully created."
      redirect_to notebook_section_notices_path(section_id: section.id)
    else
      flash.now[:error] = 'We can not create a section. Please correct the fields.'
      render 'sections/new', locals: { section: section }, status: 422
    end
  end

  def edit
    # current_section...
  end

  def update
    # current_section...
  end

  def destroy
    # current_section...
  end

  private

  def section_params
    params.require(:section).permit(:name, :description)
  end
end
