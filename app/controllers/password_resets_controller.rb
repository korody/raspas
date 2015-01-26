class PasswordResetsController < ApplicationController
  before_action :ensure_logged_out
  before_action :validate_email_or_username, only: :create

  def new
  end

  def create
    if user = User.find_by_email_or_username(sanitize(params[:email_or_username]))
      user.create_reset_digest
      # user.send_password_reset_email
      redirect_to login_path, success: t_scoped(:success, email: user.email)
    else
      flash.now[:danger] = t_scoped(:user_not_found, email: params[:email_or_username])
      render :new
    end
  end

  def edit
  end

  def update
  end

private

  def validate_email_or_username
    unless params[:email_or_username].present?
      flash.now[:danger] = t_scoped(:value_not_provided)
      render :new
    end
  end
end
