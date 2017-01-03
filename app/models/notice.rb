class Notice
  include Mongoid::Document

  field :name
  field :text

  embedded_in :section
end
