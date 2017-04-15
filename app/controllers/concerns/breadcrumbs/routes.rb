module Breadcrumbs
  module Routes
    alias_attribute :r, :routes

    def routes
      @routes ||= Rails.application.routes.url_helpers
    end
  end
end
