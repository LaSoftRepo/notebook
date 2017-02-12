class Section
  include Mongoid::Document

  field :name
  field :description

  embedded_in :notebook
  embeds_many :notices
  embeds_many :sub_sections, class_name: 'Section'
end
