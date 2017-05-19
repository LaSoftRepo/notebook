class Notebook
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortID

  field :name, type: String

  embeds_many :sections

  belongs_to :user

  validates :name, presence: true

  default_scope order(created_at: :desc)

  def find_section(id)
    section = sections.where(id: id).first

    unless section
      sections.each do |s|
        section = s.find_section id
        break if section
      end
    end

    section
  end
end
