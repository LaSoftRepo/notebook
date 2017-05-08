module Breadcrumbs
  module Notebook
    extend ActiveSupport::Concern

    included do
      include CrumbsBeforeRender

      private

      def add_breadcrumbs(action)
        case action
        when :index
          add_breadcrumb t('titles.home'), root_path
        when :new, :create
          add_breadcrumbs(:index)
          add_breadcrumb t('titles.notebook.index'), notebooks_path
        when :edit, :update
          add_breadcrumbs(:new)
          add_breadcrumb @notebook.name, notebook_sections_path(notebook_id: @notebook.id)
        end
      end
    end
  end
end
