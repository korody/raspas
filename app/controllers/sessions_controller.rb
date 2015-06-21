using StringExtensions

class SessionsController < ApplicationController
  before_action :ensure_logged_out, except: :destroy
  before_action :validate_login_and_password, only: :create

  def new
  end

  def create
    user = User.find_by_login(params[:login].sanitize)
    if user && user.authenticate(params[:password])
      log_in user
      redirect_back_or root_path, message: t_scoped(:success)
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

  def validate_login_and_password
    unless params[:login].present? && params[:password].present?
      flash.now[:danger] = t_scoped(:value_not_provided)
      render :new
    end
  end
end
