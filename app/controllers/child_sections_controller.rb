class ChildSectionsController < ApplicationController
  include Breadcrumbs::ChildSection
  before_action :authenticate_user

  def index
    @sections = current_section.child_sections
    render 'sections/index'
  end

  def new
    @section = current_section.child_sections.build
    render 'sections/new'
  end

  def create
    @section = recorder.create(section_params)
    if @section.valid?
      flash[:success] = t('created', name: @section.name)
      redirect_to notebook_section_notices_path(section_id: @section.id)
    else
      flash.now[:error] = t('not_created', name: 'subsection')
      render 'sections/new', status: 422
    end
  end

  private

  def recorder
    ChildSectionRecorder.new(parent_section: current_section)
  end

  def section_params
    params.require(:section).permit(:name, :description)
  end
end
