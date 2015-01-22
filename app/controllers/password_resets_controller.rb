class PasswordResetsController < ApplicationController
  before_action :ensure_logged_out

  def new
  end

  def create
    if sanitize_input.empty?
      flash.now[:danger] = i18n_message_for(:value_not_provided)
      render :new
    elsif user = User.find_by_email_or_username(sanitize_input)
      user.create_reset_digest
      # user.send_password_reset_email
      redirect_to login_path, success: i18n_message_for(:success, email: user.email)
    else
      flash.now[:danger] = i18n_message_for(:user_not_found, email: sanitize_input)
      render :new
    end
  end

  def edit
  end

  def update
  end

private

  def sanitize_input
    params[:email_or_username].strip.downcase if params[:email_or_username]
  end
end
