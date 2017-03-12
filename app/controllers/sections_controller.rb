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
    section = recorder.create(section_params, params[:parent_section_id])
    if section.save
      flash[:success] = "#{section.name} successfully created."
      redirect_to notebook_section_notices_path(section_id: section.id)
    else
      flash.now[:error] = 'We can not create a section. Please correct the fields.'
      render 'sections/new', locals: { section: section }, status: 422
    end
  rescue SectionRecorder::TooDeepEmbedding
    flash[:warning] = 'We can not create a section. Embedding level is too deep.'
    redirect_to notebook_sections_path(current_notebook)
  end

  private

    def recorder(section = nil)
      SectionRecorder.new(notebook: current_notebook, section: section)
    end

    def section_params
      params.require(:section).permit(:name, :description)
    end
end
