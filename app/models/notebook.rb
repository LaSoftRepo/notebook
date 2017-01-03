class Notebook
  include Mongoid::Document

  field :name

  embeds_many :sections

  belongs_to :user
end
