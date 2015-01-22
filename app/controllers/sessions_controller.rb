class SessionsController < ApplicationController
  before_action :ensure_logged_out, except: :destroy

  def new
  end

  def create
    user = User.find_by_email_or_username(sanitized_input)
    if user && user.authenticate(params[:password])
      log_in user
      redirect_back_or profile_path, message: i18n_message_for(:success)
    else
      flash.now[:danger] = i18n_message_for(:failure)
      render :new
    end
  end

  def destroy
    log_out
    redirect_to login_path, success: i18n_message_for(:success)
  end

private

  def sanitized_input
    params[:email_or_username].downcase.strip if params[:email_or_username].present?
  end
end
