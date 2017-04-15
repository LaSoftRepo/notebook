module Breadcrumbs
  module Notebook
    extend ActiveSupport::Concern

    included do
      include CrumbsBeforeRender

      def add_breadcrumbs(action)
        case action
        when :index
          add_breadcrumb 'Home', root_path
        when :new, :create
          add_breadcrumb 'Home', root_path
          add_breadcrumb 'Notebooks', notebooks_path
        end
      end
    end
  end
end
