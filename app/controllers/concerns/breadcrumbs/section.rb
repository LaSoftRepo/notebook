module Breadcrumbs
  module Section
    extend ActiveSupport::Concern

    included do
      include CrumbsBeforeRender

      def add_breadcrumbs(action)
        case action
        when :index
          add_breadcrumb 'Home', root_path
          add_breadcrumb 'Notebooks', notebooks_path
          add_breadcrumb current_notebook.name, notebook_path(current_notebook)
        when :new, :create
          add_breadcrumb 'Home', root_path
          add_breadcrumb 'Notebooks', notebooks_path
          add_breadcrumb current_notebook.name, notebook_path(current_notebook)
          add_breadcrumb 'Sections', notebook_sections_path(current_notebook)
        end
      end
    end
  end
end
