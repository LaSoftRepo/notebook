class SectionsController < ApplicationController
  before_action :authenticate_user

  def index
    sections = current_notebook.sections
    render 'sections/index', locals: { sections: sections }
  end

  def new
    section = if params[:parent_section_id]
      current_notebook.find_section(params[:parent_section_id]).child_sections.build
    else
      current_notebook.sections.build
    end
    render 'sections/new', locals: { section: section }
  end

  def create
    section = if params[:parent_section_id]
      current_notebook.find_section(params[:parent_section_id])
        .child_sections.build section_params
    else
      current_notebook.sections.build section_params
    end

    if section.save
      flash[:success] = "#{section.name} successfully created."
      redirect_to root_path # tmp
    else
      flash.now[:error] = 'We can not create a section. Please correct the fields.'
      render 'sections/new', locals: { section: section }, status: 422
    end
  end

  private

    def section_params
      params.require(:section).permit(:name, :description)
    end
end
