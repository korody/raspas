class UsernameFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless Username.valid?(value)
      object.errors.add(attribute)
    end
  end
end
