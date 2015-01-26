class SessionsController < ApplicationController
  before_action :ensure_logged_out, except: :destroy
  before_action :validate_email_or_username_and_password, only: :create

  def new
  end

  def create
    user = User.find_by_email_or_username(sanitize(params[:email_or_username]))
    if user && user.authenticate(params[:password])
      log_in user
      redirect_back_or profile_path, message: t_scoped(:success)
    else
      flash.now[:danger] = t_scoped(:failure)
      render :new
    end
  end

  def destroy
    log_out
    redirect_to login_path, success: t_scoped(:success)
  end

private

  def validate_email_or_username_and_password
    unless params[:email_or_username].present? && params[:password].present?
      flash.now[:danger] = t_scoped(:value_not_provided)
      render :new
    end
  end
end
