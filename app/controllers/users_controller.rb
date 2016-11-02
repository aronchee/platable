class UsersController < ApplicationController

	before_action :authenticate_user!

  def edit
  end

  def update
  end
  
  private

  def user_params
  	params.require(:user).permit(:email, :encrypted_password, :provider,:uid)
  end

end
