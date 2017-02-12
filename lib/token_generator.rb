module TokenGenerator

  def generate
    SecureRandom.uuid
  end

  module_function :generate
end
