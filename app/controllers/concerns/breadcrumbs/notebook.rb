module Breadcrumbs
  module Notebook
    extend ActiveSupport::Concern

    included do
      include AppRoutes
      include CrumbsBeforeRender

      def add_breadcrumbs(action)
        case action
        when :index
          add_breadcrumb 'Home', app_routes.root_path
        when :new
          add_breadcrumb 'Home', app_routes.root_path
          add_breadcrumb 'Notebooks', app_routes.notebooks_path
        end
      end
    end
  end
end
