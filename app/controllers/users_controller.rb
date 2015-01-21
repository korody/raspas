class UsersController < ApplicationController
  before_action :ensure_logged_in, :set_user

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to profile_path, success: i18n_message_for(:success)
    else
      flash.now[:danger] = i18n_message_for(:failure)
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
