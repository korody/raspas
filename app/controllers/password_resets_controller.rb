using StringExtensions

class PasswordResetsController < ApplicationController
  before_action :ensure_logged_out
  before_action :validate_email_or_username, only: :create
  before_action :get_user_or_redirect, only: [:edit, :update]

  def new
  end

  def create
    if @user = User.find_by_email_or_username(params[:email_or_username].sanitize)
      @user.create_reset_digest
      UserMailer.password_reset_request(@user).deliver_now
      redirect_to login_path, success: t_scoped(:success, email: @user.email)
    else
      flash.now[:danger] = t_scoped(:user_not_found, email: params[:email_or_username]).html_safe
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(password: params[:user][:password])
      redirect_to login_path, success: t_scoped(:success)
    else
      flash.now[:danger] = t_scoped(:failure)
      render :edit
    end
  end

private

  def validate_email_or_username
    if params[:email_or_username].blank?
      flash.now[:danger] = t_scoped(:value_not_provided)
      render :new
    end
  end

  def get_user_or_redirect
    if @user = User.find_by_email_or_username(params[:email].sanitize)
      if @user.reset_expired?
        redirect_user :reset_expired
      elsif !@user.authenticated?(:reset_digest, params[:id])
        redirect_user :not_authorized
      end
    else
      redirect_user :user_not_found
    end
  end

  def redirect_user(message)
    redirect_to new_password_reset_path, danger: t_scoped(message)
  end
end
