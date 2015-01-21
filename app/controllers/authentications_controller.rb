class AuthenticationsController < ApplicationController
  def new
  end

  def create
    auth = env["omniauth.auth"]
    # Find an authentication or create an authentication
    authentication = Authentication.with_omniauth(auth)
    if logged_in?
      if authentication.user == current_user
        # user is signed in so they are trying to link an authentication with their
        # account. But we found the authentication and the user associated with it
        # is the current user. So the authentication is already associated with
        # this user. So let's display an error message.
        redirect_to profile_path(current_user), info: "este perfil já está vinculado"
      else
        # The authentication is not associated with the current_user so lets
        # associate the authentication
        authentication.user = current_user
        authentication.save
        redirect_to profile_path(current_user), success: "perfil vinculado"
      end
    else # no user is signed_in
      if authentication.user.present?
        # The authentication we found had a user associated with it so let's log them in here
        # params[:remember_me] == '1' ? remember(authentication.user : forget(authentication.user)
        log_in authentication.user
        redirect_to profile_path(current_user), success: "bem-vindo(a) de volta"
      else
        # The authentication has no user assigned and there is no user signed in
        # Look for a user with same email or create a new one
        @user = User.from_omniauth(auth)
        if @user.persisted?
          # We can now link the authentication with the user and log him in
          @user.authentications << authentication
          log_in @user
          redirect_to profile_path(current_user), success: "bem-vindo(a) ao Nimbus!"
        else
          render 'authentications/new'
        end
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
    redirect_to register_path, danger: "ops! Não foi possível conectar no momento."
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :display_username, :password)
  end
end