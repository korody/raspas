class AuthenticationsController < ApplicationController

  def create
    auth = Authentication.from_omniauth(env["omniauth.auth"])

    if logged_in?
      current_user.add_auth(auth) unless current_user.authentications.include?(auth)
      redirect_to profile_path, success: t_scoped(:auth_added, provider: auth.provider.humanize)
    else
      if user = auth.user
        login_user_and_redirect(user)
      elsif user = User.find_by(email: auth['info']['email'])
        user.add_auth(auth)
        login_user_and_redirect(user)
      else
        redirect_to new_auth_registration_path(auth_id: auth.id, access_token: auth.access_token)
      end
    end
  end

  def failure
    redirect_to register_path, danger: t_scoped(:failure)
  end

private

  def login_user_and_redirect(user)
    log_in user
    redirect_to profile_path, success: t_scoped(:welcome_back)
  end
end
