class UsersController < ApplicationController
  before_action :ensure_logged_in, :set_user

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to profile_path, success: t_scoped(:success)
    else
      flash.now[:danger] = t_scoped(:failure)
      render :edit
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :display_username, :password)
  end

  def set_user
    @user = current_user
  end
end
