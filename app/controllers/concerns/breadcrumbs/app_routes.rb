module Breadcrumbs
  module AppRoutes
    def app_routes
      @app_routes ||= Rails.application.routes.url_helpers
    end
  end
end
