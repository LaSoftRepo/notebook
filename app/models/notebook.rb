class Notebook
  include Mongoid::Document
  include ShortID

  field :name

  embeds_many :sections

  belongs_to :user
end
