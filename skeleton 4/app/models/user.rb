
# Store the User's user_name and password_digest.
# As ever, toss on necessary constraints and validations.
# Also create a session_token column.
# Require the session token to be present. This means you'll need a after_initialize callback to set the token if it's not already set.
# Add a unique index on session_token; no two users should share a session token.
# Write yourself a User#reset_session_token! method. Go on, you're worth it! Use yourself a SecureRandom to generate a token.
# Write a #password=(password) setter method that writes the password_digest attribute with the hash of the given password.
# Write a #is_password?(password) method that verifies a password.
# Write a ::find_by_credentials(user_name, password) method that returns the user with the given name if the password is correct.

class User < ApplicationRecord
  validates :username,:session_token, :password_digest, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}
  after_initialize :ensure_session_token
  attr_reader :password

  def valid_password?(password)

  end

  def self.find_by_credentials(username,password)
    user = User.find_by(username: username)
    return nil unless user
    if BCrypt::Password.new(user.password_digest).is_password?(password)
      user
    else
      nil
    end
  end


  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end



  def ensure_session_token
    self.session_token ||= self.session_token = SecureRandom::base64(16)
  end

  def reset_session_token!
    ensure_session_token
    self.save
    self.session_token
  end
end
