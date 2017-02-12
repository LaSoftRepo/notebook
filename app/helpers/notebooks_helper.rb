module NotebooksHelper
  def current_notebook
    @current_notebook ||= current_user.notebooks.find params[:notebook_id]
  end
end
