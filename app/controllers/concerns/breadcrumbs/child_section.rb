module Breadcrumbs
  module ChildSection
    extend ActiveSupport::Concern

    included do
      include CrumbsBeforeRender

      def add_breadcrumbs(action)
        case action
        when :index
          add_breadcrumb t('title.home'), root_path
          add_breadcrumb t('title.notebook.index'), notebooks_path
          add_breadcrumb current_notebook.name, notebook_sections_path(current_notebook)
          current_section.parent_sections.reverse.each do |section|
            add_breadcrumb section.name, notebook_child_sections_path(parent_section_id: section.id)
          end
        when :new, :create
          add_breadcrumbs(:index)
          add_breadcrumb current_section.name, notebook_child_sections_path(parent_section_id: current_section)
        end
      end
    end
  end
end
