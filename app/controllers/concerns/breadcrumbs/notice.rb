module Breadcrumbs
  module Notice
    extend ActiveSupport::Concern

    included do
      include CrumbsBeforeRender

      def add_breadcrumbs(action)
        case action
        when :index
          add_breadcrumb t('title.notebook.index'), notebooks_path
          add_breadcrumb current_notebook.name, notebook_path(current_notebook)
          add_breadcrumb t('title.section.index'), notebook_sections_path(current_notebook)
          current_section.parent_sections.reverse.push(current_section).each do |s|
            add_breadcrumb s.name, notebook_section_path(notebook_id: current_notebook, id: s.id)
          end
        when :new, :create, :show
          add_breadcrumbs(:index)
          add_breadcrumb t('title.notice.index'), notebook_section_notices_path
        end
      end
    end
  end
end
