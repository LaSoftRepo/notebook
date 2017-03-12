class Section
  include Mongoid::Document
  include ShortID

  field :name, type: String
  field :description, type: String

  embedded_in :notebook
  embeds_many :notices
  recursively_embeds_many

  validates :name, presence: true

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
end
