class SectionsController < ApplicationController
  before_action :authenticate_user

  def index
    sections = current_notebook.sections
    render 'sections/index', locals: { sections: sections }
  end
end
