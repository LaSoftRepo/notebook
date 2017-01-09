module Encryptor

  def encrypt(token)
    Digest::SHA1.hexdigest(token)
  end

  module_function :encrypt
end
