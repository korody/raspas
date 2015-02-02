class EmailAddress
  VALID_EMAIL_ADDRESS_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def self.malformed?(email)
    email !~ VALID_EMAIL_ADDRESS_REGEX
  end

  def self.valid?(email)
    !malformed?(email)
  end
end
