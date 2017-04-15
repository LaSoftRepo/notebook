module Breadcrumbs
  module ChildSection
    extend ActiveSupport::Concern

    included do
      include CrumbsBeforeRender

      def add_breadcrumbs(action)
        case action
        when :new, :create
          add_breadcrumb 'Home', root_path
          add_breadcrumb 'Notebooks', notebooks_path
          add_breadcrumb current_notebook.name, notebook_path(current_notebook)
          add_breadcrumb 'Sections', notebook_sections_path(current_notebook)
          @parent_section.parent_sections.reverse.push(@parent_section).each do |s|
            add_breadcrumb s.name, notebook_section_path(notebook_id: current_notebook, id: s.id)
          end
        end
      end
    end
  end
end
