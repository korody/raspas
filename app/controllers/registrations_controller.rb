class RegistrationsController < ApplicationController
  def new
    @user = User.new
    # raise instance_variables.inspect
    # raise instance_variable_get(:@_lookup_context).inspect
    # raise @virtual_path.to_s
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

private

  def user_params
    params.require(:user).permit(:name, :email, :display_username, :password)
  end
end
