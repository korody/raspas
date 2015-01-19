class ApplicationController < ActionController::Base
  include UsesSecureController
  include I18nMessenger

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :danger, :success, :warning, :info
end
