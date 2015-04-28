class MaterialFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, to: :@template

  %w[text_field password_field].each do |method_name|
    define_method(method_name) do |name, *args|
      options = args.extract_options!
      super(name, options) + field_label(name, options) + errors_for(name)
    end
  end

private

  def field_label(name, options)
    label name, options[:label], class: ('active' unless object.send(name).blank?)
  end

  def errors_for(name)
    object.errors.full_messages_for(name).map do |message|
      content_tag :p, message, class: 'field-error'
    end.join.html_safe
  end

  def required_field?(name)
    object.class.validators_on(name).any? do |validator|
      validator.kind_of? ActiveModel::Validations::PresenceValidator
    end
  end
end
