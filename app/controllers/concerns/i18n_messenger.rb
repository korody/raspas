module I18nMessenger
  def i18n_message_for(key, **args)
    t(key, scope: scope, **args)
  end

private

  def scope
    [:controllers, controller_name, action_name]
  end
end
