module Breadcrumbs
  module Base
    module Class
      def add_breadcrumbs_to(actions)
        actions.each do |action|
          send(:before_action, action.to_s.concat('_crumbs').to_sym, only: action)
        end
      end
    end

    module Object
      def app_routes
        @app_routes ||= Rails.application.routes.url_helpers
      end
    end
  end
end
