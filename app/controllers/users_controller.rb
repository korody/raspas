class UsersController < ApplicationController
  before_action :ensure_logged_in, :set_user

  def show
  end

  def edit
  end

private

  def set_user
    @user = current_user
  end
end
