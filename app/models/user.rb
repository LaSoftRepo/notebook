class User
  include Mongoid::Document
  include ShortID

  field :name, type: String
  field :email, type: String
  field :password_hash, type: String
  field :password_salt, type: String
  field :auth_token, type: String
  field :password_reset_token, type: String
  field :password_reset_sent_at, type: DateTime

  has_many :notebooks

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  attr_accessor :password, :password_validation_is_required

  before_save { email.downcase! }
  before_save :encrypt_password
  before_create :generate_auth_token

  validates :password, presence: true, length: { minimum: 6 }, confirmation: true,
    if: :password_validation_is_required
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

  def generate_auth_token
    self.auth_token = Encryptor.encrypt(TokenGenerator.generate)
  end

  private

    def encrypt_password
      if password.present?
        self.password_salt = BCrypt::Engine.generate_salt
        self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
      end
    end
end
