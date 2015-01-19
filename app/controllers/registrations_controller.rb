class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      redirect_to profile_path(@user)
    else
      flash.now[:danger] = i18n_message_for :failure
      render :new
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :display_username, :password)
  end
end
