class ChildSectionsController < ApplicationController
  include Breadcrumbs::ChildSection
  before_action :authenticate_user
  before_action :set_parent_section

  def new
    section = @parent_section.child_sections.build
    render 'sections/new', locals: { section: section }
  end

  def create
    section = recorder.create(section_params)
    if section.valid?
      flash[:success] = "#{section.name} successfully created."
      redirect_to notebook_section_notices_path(section_id: section.id)
    else
      flash.now[:error] = 'We can not create a section. Please correct the fields.'
      render 'sections/new', locals: { section: section }, status: 422
    end
  end

  private

  def set_parent_section
    @parent_section ||=
      current_notebook.find_section(params[:parent_section_id])
  end

  def recorder
    ChildSectionRecorder.new(parent_section: @parent_section)
  end

  def section_params
    params.require(:section).permit(:name, :description)
  end
end
