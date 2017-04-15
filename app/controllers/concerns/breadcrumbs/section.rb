module Breadcrumbs
  module Section
    extend ActiveSupport::Concern

    included do
      include CrumbsBeforeRender

      def add_breadcrumbs(action)
        case action
        when :index
          add_breadcrumb t('title.notebook.index'), notebooks_path
          add_breadcrumb current_notebook.name, notebook_path(current_notebook)
        when :new, :create
          add_breadcrumbs(:index)
          add_breadcrumb t('title.section.index'), notebook_sections_path(current_notebook)
        end
      end
    end
  end
end
