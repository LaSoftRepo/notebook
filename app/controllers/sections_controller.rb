class SectionsController < ApplicationController
  include Breadcrumbs::Section
  before_action :authenticate_user
  # TODO: Add before action "check_notebook". You will check if notebook
  # belonds to current user. Maybe current_notebook helper should return nil
  # if there's no notebook found. Testing will be very easy

  def index
    @sections = current_notebook.sections
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

  private

  def section_params
    params.require(:section).permit(:name, :description)
  end
end
