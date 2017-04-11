module Breadcrumbs
  module Notebook
    extend ActiveSupport::Concern

    included do
      include Base::Object
      extend  Base::Class

      cattr_reader :actions do
        [:index, :new]
      end

      def index_crumbs
        add_breadcrumb 'Home', app_routes.root_path
      end

      def new_crumbs
        add_breadcrumb 'Home', app_routes.root_path
        add_breadcrumb 'Notebooks', app_routes.notebooks_path
      end

      add_breadcrumbs_to(actions)
    end
  end
end
