module Breadcrumbs
  module Notebook
    extend ActiveSupport::Concern

    included do
      include CrumbsBeforeRender

      def add_breadcrumbs(action)
        case action
        when :index
          add_breadcrumb t('title.home'), root_path
        when :new
          add_breadcrumbs(:index)
          add_breadcrumb t('title.notebook.index'), notebooks_path
        end
      end
    end
  end
end
