module UsesSecureController
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :logged_in?
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: user_id)
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember_digest, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def ensure_logged_in
    unless logged_in?
      store_location
      redirect_to log_in_path
    end
  end

  def ensure_logged_out
    redirect_to root_path if logged_in?
  end

  def redirect_back_or(default)
    location = session[:forwarding_url] || default
    redirect_to(location, success: t('success', scope: [:controllers, :sessions, :create]))
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
