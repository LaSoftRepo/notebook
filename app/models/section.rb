class Section
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortID

  field :name, type: String
  field :description, type: String

  MAX_EMBEDDING_LEVEL = 3

  embedded_in :notebook
  embeds_many :notices
  recursively_embeds_many

  validates :name, presence: true

  default_scope -> { order(created_at: :desc) }

  def find_section(id)
    section = child_sections.where(id: id).first

    unless section
      child_sections.each do |s|
        section = s.find_section id
        break if section
      end
    end

    section
  end

  def can_create_child_section?
    embedding_level = 1
    section = self

    while section.parent_section?
      section = section.parent_section
      embedding_level += 1
    end

    embedding_level <= MAX_EMBEDDING_LEVEL
  end

  def parent_sections
    parents = []
    section = self

    while section.parent_section?
      section = section.parent_section
      parents << section
    end

    parents
  end
end
