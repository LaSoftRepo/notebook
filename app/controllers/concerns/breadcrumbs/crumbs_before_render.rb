module Breadcrumbs
  module CrumbsBeforeRender
    def render(*args)
      add_breadcrumbs(self.action_name.to_sym)
      super
    end
  end
end
