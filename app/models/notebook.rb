class Notebook
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortID

  field :name

  embeds_many :sections

  belongs_to :user

  validates :name, presence: true
end
