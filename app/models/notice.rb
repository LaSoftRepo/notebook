class Notice
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortID

  field :name, type: String
  field :text, type: String

  embedded_in :section
end
