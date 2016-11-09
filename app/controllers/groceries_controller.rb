class GroceriesController < ApplicationController
	before_action :authenticate_user!

  def index
  	@all_ingredients = Ingredient.pluck(:name).sort
    @user = current_user
  	@grocery = Grocery.new
  	@unchecked_groceries = current_user.groceries.where(checked: false).joins(:ingredient).order("ingredients.name")
  	@checked_groceries = current_user.groceries.where(checked: true).joins(:ingredient).order("ingredients.name")
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
  	@groceries = current_user.groceries
    @groceries.destroy_all

  	redirect_to user_groceries_path
  end

  def shop
  end

  def create_from_plan
    @plan = Plan.find(params[:id])
    @plan.recipe.ingredients.each do |x|
      current_user.groceries.find_or_create_by(ingredient_id: x.id)
    end
    redirect_to '/plans'
  end

  def create_from_recipe
    @recipe = Recipe.find(params[:id])
    @recipe.ingredients.each do |x|
      current_user.groceries.find_or_create_by(ingredient_id: x.id)
    end
    redirect_to @recipe
  end

  private
  def grocery_params
  	params.require(:grocery).permit(:ingredient_id, :user_id)

  end
end
