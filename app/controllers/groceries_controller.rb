class GroceriesController < ApplicationController
	before_action :authenticate_user!

  def index
  	@all_ingredients = Ingredient.pluck(:name).sort
    @user = current_user
  	@grocery = Grocery.new
  	@unchecked_groceries = current_user.groceries.where(checked: false)
  	@checked_groceries = current_user.groceries.where(checked: true)
  end

  def create
  	@grocery = current_user.groceries.new

    if Ingredient.find_by_name(params[:ingredient_name])
    	@grocery[:ingredient_id] = Ingredient.find_by_name(params[:ingredient_name]).id
    	@grocery.save
    else
      Ingredient.create(name: params[:ingredient_name])
      @grocery[:ingredient_id] = Ingredient.find_by_name(params[:ingredient_name]).id
      @grocery.save
    end

  	redirect_to user_groceries_path
  end

  def update
  	@grocery = Grocery.find(params[:id])
  	if params[:unchecked] == "true" # uncheck => checked
  		@grocery.update(checked: true)
  	elsif params[:checked] == "false" # if the checked item continue to be checked and they press update, no change
  		@grocery.update(checked: true)
  	else
  		@grocery.update(checked: false) # if they uncheck the box, :checked = nil, then
  	end

  	redirect_to user_groceries_path
  end

  def destroy
  	if params[:id] == "clear_checked"
  		@groceries = Grocery.where(user_id: params[:user_id], checked: true)
  		@groceries.each do |x|
  			x.destroy
  		end
    elsif params[:id] == "clear_unchecked"
      @groceries = Grocery.where(user_id: params[:user_id], checked: false)
      @groceries.each do |x|
        x.destroy
      end
  	else
	  	@grocery = Grocery.find(params[:id])
	  	@grocery.destroy
  	end

  	redirect_to user_groceries_path
  end

  def shop #for online shop page
  end

  private
  def grocery_params
  	params.require(:grocery).permit(:ingredient_id, :user_id)

  end
end
