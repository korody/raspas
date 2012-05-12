# encoding: utf-8
module SessionsHelper

  def home
    request.fullpath == root_path
  end	

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signin(user)
      self.current_user = user
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

   def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Opa! Vamos por partes. Você já fez o login?"
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end
  
end