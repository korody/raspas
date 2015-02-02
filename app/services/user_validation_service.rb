class UserValidationService
  attr_reader :attribute, :value, :errors

  PERMITTED_ATTRS = %w(email display_username)

  def initialize(attribute:, value:)
    raise "Unpermitted attribute #{attribute}" unless PERMITTED_ATTRS.include?(attribute)

    @attribute = attribute
    @value = value
  end

  def valid?
    validate
    errors.empty?
  end

private

  attr_writer :errors

  def validate
    user = User.new(attribute.to_sym => value)

    if user.valid?
      self.errors = []
    else
      self.errors = user.errors.full_messages_for(attribute.to_sym)
    end
  end

  def taken?
    User.exists?(attribute.to_sym => value)
  end
end
