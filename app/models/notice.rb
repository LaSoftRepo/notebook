class Notice
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortID

  field :name, type: String
  field :text, type: String

  embedded_in :section

  validates :name, :text, presence: true

  default_scope order(created_at: :desc)
end
