class SectionRecorder

  class TooDeepEmbedding < StandardError; end

  def initialize(args = {})
    args.reverse_merge!({ section: nil })
    @notebook = args[:notebook]
    @section = args[:section]
  end

  def create(params, parent_section_id = nil)
    section = if parent_section_id.present?
      parent_section = @notebook.find_section(parent_section_id)
      raise TooDeepEmbedding unless parent_section.can_create_child_section?
      parent_section.child_sections.create params
    else
      @notebook.sections.create params
    end
  end
end
