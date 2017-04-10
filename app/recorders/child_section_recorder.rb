class ChildSectionRecorder

  class TooDeepEmbedding < StandardError; end

  attr_reader :parent_section

  def initialize(args = {})
    @parent_section = args[:parent_section]
  end

  def create(params)
    raise TooDeepEmbedding unless parent_section.can_create_child_section?
    parent_section.child_sections.create(params)
  end
end
