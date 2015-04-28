class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, to: :@template

  %w[text_field password_field].each do |method_name|
    define_method(method_name) do |name, *args|
      options = args.extract_options!
      if options[:hide_label]
        options.reverse_merge!(placeholder: object.class.human_attribute_name(name))
        super(name, options) + errors_for(name)
      else
        field_label(name, options) + super(name, options) + errors_for(name)
      end
    end
  end

private

  def field_label(name, options)
    label name, options[:label]
  end

  def errors_for(name)
    object.errors.full_messages_for(name).map do |message|
      content_tag :p, message, class: 'error-message'
    end.join.html_safe
  end

  def objectify_options(options)
    super.except(:label)
  end

  def required_field?(name)
    object.class.validators_on(name).any? do |validator|
      validator.kind_of? ActiveModel::Validations::PresenceValidator
    end
  end
end
