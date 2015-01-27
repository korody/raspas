class RegistrationsController < ApplicationController
  include UserParameters

  def new
    @user = User.new
  end

  def create
    @user = UserCreationService.create(user_params)

    if @user.persisted?
      log_in @user
      redirect_to profile_path
    else
      flash.now[:danger] = t_scoped(:failure)
      render :new
    end
  end
end
