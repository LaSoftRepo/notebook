module Breadcrumbs
  module Section
    extend ActiveSupport::Concern

    included do
      include CrumbsBeforeRender

      private

      def add_breadcrumbs(action)
        case action
        when :index
          add_breadcrumb t('titles.home'), root_path
          add_breadcrumb t('titles.notebook.index'), notebooks_path
        when :new, :create
          add_breadcrumbs(:index)
          add_breadcrumb current_notebook.name, notebook_sections_path(current_notebook)
        end
      end
    end
  end
end
