class ApplicationController < ActionController::Base
  include UsesSecureController

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :danger, :success, :warning, :info

private

  def deny_access
    render text: "Não autorizado.", status: :unauthorized
  end

  def redirect_back(options)
    redirect_to :back, options
  rescue ActionController::RedirectBackError
    redirect_to root_path, options
  end
end
