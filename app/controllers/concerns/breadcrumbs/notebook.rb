module Breadcrumbs
  module Notebook
    extend ActiveSupport::Concern

    included do
      include CrumbsBeforeRender

      def add_breadcrumbs(action)
        case action
        when :new, :create
          add_breadcrumb t('title.notebook.index'), notebooks_path
        end
      end
    end
  end
end
