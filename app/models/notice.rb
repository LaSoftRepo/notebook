class Notice
  include Mongoid::Document
  include ShortID

  field :name, type: String
  field :text, type: String

  embedded_in :section
end
