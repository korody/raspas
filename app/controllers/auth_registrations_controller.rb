class AuthRegistrationsController < ApplicationController
  include UserParameters

  before_action :validate_authentication

  layout 'sessions'

  def new
    @user = User.initialize_from_auth(@auth)
  end

  def create
    @user = UserCreationService.create(user_params, @auth)

    if @user.persisted?
      log_in @user
      redirect_back_or root_path
    else
      flash.now[:danger] = t_scoped(:failure)
      render :new
    end
  end

private

  def validate_authentication
    if params[:access_token].blank?
      deny_access
    else @auth = Authentication.find(params[:auth_id])
      deny_access unless @auth.authenticated?(:access_token_digest, params[:access_token])
    end
  end
end
