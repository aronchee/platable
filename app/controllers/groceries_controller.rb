class GroceriesController < ApplicationController
	before_action :authenticate_user!


  def index
  	@user = current_user
  	@unchecked_groceries = Grocery.where(user_id: @user.id, checked: false)
  	@checked_groceries = Grocery.where(user_id: @user.id, checked: true)
  end

  def new
  	@user = current_user
  	@grocery = Grocery.new

  end

  def create
  	@grocery = Grocery.new(grocery_params)
  	@grocery[:user_id] = params[:user_id]
  	@grocery.save

  	redirect_to user_groceries_path
  end

  def update

  	@grocery = Grocery.find(params[:id])

  	if params[:checked] == "true"
  		@grocery.update(checked: true)
  	else
  		@grocery.update(checked: false)
  	end

  	redirect_to user_groceries_path
  end

  def destroy

  	@grocery = Grocery.find(params[:id])
  	@grocery.destroy

  	redirect_to user_groceries_path
  end

  private
  def grocery_params
  	params.require(:grocery).permit(:ingredient_id, :user_id)

  end
end
