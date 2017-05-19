module Breadcrumbs
  module Notice
    extend ActiveSupport::Concern

    included do
      include CrumbsBeforeRender

      private

      def add_breadcrumbs(action)
        case action
        when :index
          add_breadcrumb t('titles.home'), root_path
          add_breadcrumb t('titles.notebook.index'), notebooks_path
          add_breadcrumb current_notebook.name, notebook_sections_path
          current_section.parent_sections.reverse.each do |section|
            add_breadcrumb(
              section.name,
              notebook_section_notices_path(section_id: section.id)
            )
          end
        when :new, :create, :show
          add_breadcrumbs(:index)
          add_breadcrumb current_section.name, notebook_section_notices_path
        when :edit
          add_breadcrumbs(:new)
          add_breadcrumb(
            @notice.name,
            notebook_section_notice_path(id: @notice.id)
          )
        end
      end
    end
  end
end
