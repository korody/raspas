class Username
  VALID_USERNAME_REGEX = /^[a-z0-9][a-z0-9_]+$/i

  def self.valid?(username)
    username =~ VALID_USERNAME_REGEX
  end
end
