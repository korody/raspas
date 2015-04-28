class AuthRegistrationsController < ApplicationController
  include UserParameters

  before_action :validate_authentication

  layout 'sessions'

  def new
    @user = User.initialize_from_auth(@auth)
  end

  def create
    @user = User.new(user_params)
    @user.add_auth(@auth)

    if @user.save
      log_in @user
      redirect_to profile_path, success: t_scoped(:success)
    else
      flash.now[:danger] = t_scoped(:failure)
      render :new
    end
  end

private

  def validate_authentication
    if params[:auth_id].blank? || params[:access_token].blank?
      redirect_to login_path
    else
      @auth = Authentication.find(params[:auth_id])

      unless @auth.authenticated?(:access_token_digest, params[:access_token])
        redirect_to login_path, danger: t_scoped(:not_authorized)
      end
    end
  end
end
