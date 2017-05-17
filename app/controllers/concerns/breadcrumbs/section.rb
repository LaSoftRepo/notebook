module Breadcrumbs
  module Section
    extend ActiveSupport::Concern

    included do
      include CrumbsBeforeRender

      private

      def add_breadcrumbs(action)
        case action
        when :index
          add_breadcrumb t('titles.home'), root_path
          add_breadcrumb t('titles.notebook.index'), notebooks_path
        when :new, :create
          add_breadcrumbs(:index)
          add_breadcrumb current_notebook.name, notebook_sections_path(current_notebook)
        when :edit, :update
          add_breadcrumbs(:new)
          @section.parent_sections.reverse.push(@section).each do |section|
            add_breadcrumb section.name, notebook_section_notices_path(section_id: section.id)
          end
        end
      end
    end
  end
end
