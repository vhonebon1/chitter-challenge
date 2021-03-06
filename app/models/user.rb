require 'bcrypt'

class User

  include BCrypt
  include DataMapper::Resource

  property :id, Serial
  property :email, String
  property :name, String, required: true
  property :username, String
  property :password_digest, Text

  validates_confirmation_of :password
  validates_presence_of :email
  validates_format_of :email, as: :email_address

  attr_reader :password
  attr_accessor :password_confirmation

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    user = first(email: email)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end
end
