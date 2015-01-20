class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email_or_username(params[:username])
    if user && user.authenticate(params[:password])
      log_in user
      redirect_to profile_path
    else
      flash.now[:danger] = i18n_message_for :failure
      render :new
    end
  end
end
