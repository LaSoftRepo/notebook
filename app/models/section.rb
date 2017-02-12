class Section
  include Mongoid::Document
  include ShortID

  field :name
  field :description

  embedded_in :notebook
  embeds_many :notices
  recursively_embeds_many
end
