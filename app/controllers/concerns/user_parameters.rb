module UserParameters
  private def user_params
    params.require(:user).permit(:name, :email, :display_username, :password)
  end
end
