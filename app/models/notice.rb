class Notice
  include Mongoid::Document
  include ShortID

  field :name
  field :text

  embedded_in :section
end
