class AuthenticationsController < ApplicationController
  def new
  end

  def create
    authentication = Authentication.create_from_omniauth(env["omniauth.auth"])

    if logged_in?
      if authentication.user == current_user
        redirect_to profile_path, info: i18n_message_for(:authentication_exists)
      else
        current_user << authentication
        redirect_to profile_path, success: i18n_message_for(:authentication_added)
      end
    else
      if authentication.user.present?
        log_in authentication.user
        redirect_to profile_path, success: i18n_message_for(:welcome_back)
      else
        @user = User.initialize_from_omniauth(env["omniauth.auth"])
        render 'authentications/new'
      end
    end
  end

  def complete_registration
    @user = User.new(user_params)

    if @user.save
      log_in @user
      redirect_to profile_path
    else
      flash.now[:danger] = i18n_message_for :failure
      render :new
    end
  end

  def failure
    redirect_to register_path, danger: "Ops! Não foi possível conectar no momento."
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :display_username, :password)
  end
end
