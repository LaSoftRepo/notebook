class User
  include Mongoid::Document

  field :name, type: String
  field :email, type: String
  field :password_hash, type: String
  field :password_salt, type: String

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  attr_accessor :password

  before_save { email.downcase! }
  before_save :encrypt_password

  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, on: :create
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

  def self.authenticate(email, password)
    user = where(email: email.downcase).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  # TODO: Add auth token. We should change that token each time user log in or log out. https://github.com/vetalpaprotsky/sample_app
end
