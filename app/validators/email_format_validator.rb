class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    if EmailAddress.malformed?(value)
      object.errors.add(attribute)
    end
  end
end
