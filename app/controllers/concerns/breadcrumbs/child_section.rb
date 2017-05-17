module Breadcrumbs
  module ChildSection
    extend ActiveSupport::Concern

    included do
      include CrumbsBeforeRender

      private

      def add_breadcrumbs(action)
        case action
        when :new, :create
          add_breadcrumb t('titles.home'), root_path
          add_breadcrumb t('titles.notebook.index'), notebooks_path
          add_breadcrumb current_notebook.name, notebook_sections_path(current_notebook)
          current_section.parent_sections.reverse.each do |section|
            add_breadcrumb section.name, notebook_section_notices_path(section_id: section.id)
          end
          add_breadcrumb current_section.name, notebook_section_notices_path(section_id: current_section.id)
        end
      end
    end
  end
end
