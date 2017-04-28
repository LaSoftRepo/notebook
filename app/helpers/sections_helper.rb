module SectionsHelper
  def current_section
    @current_section ||=
      current_notebook.find_section params[:section_id] || params[:parent_section_id]
  end
end
