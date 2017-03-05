module PrettyErrors
  extend ActiveSupport::Concern

  def pretty_errors
    self.errors.full_messages.join ', '
  end
end
