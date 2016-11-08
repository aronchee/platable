class UsersController < ApplicationController

	before_action :authenticate_user!
	before_action :set_user

	def show

  end

  def edit
  end

  def update
  end
  
  private

  def user_params
  	params.require(:user).permit(:email, :encrypted_password, :provider,:uid)
  end

  def set_user
  	@user = User.find(params[:id])
  end

end
