module I18nMessenger
  def i18n_message_for(key)
    t key, scope: scope
  end

private

  def scope
    [:controllers, controller_name, action_name]
  end
end
