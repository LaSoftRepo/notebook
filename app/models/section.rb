class Section
  include Mongoid::Document

  field :name
  field :description

  embeds_many :notices
  embeds_many :sub_sections, class_name: 'Section'
end
