class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to register_path
    else
      flash.now[:notice] = "Ooops!"
      render :new
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :display_username, :password)
  end
end
