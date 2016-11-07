class PlansController < ApplicationController
  def create
    @plan = current_user.plans.new(plan_params)
    if @plan.recipe == nil
      @plan.recipe = Recipe.find_by_name(params[:recipe_name])
    end
    @plan.save

    if @plan.save

      @recipe = Recipe.find(@plan.recipe_id)
      @ingredients = @recipe.ingredients.pluck(:name)
      @ingredients.each do |x|
        ingredient_id = Ingredient.find_by(name: x).id
        @grocery = Grocery.new(user_id: current_user.id, ingredient_id: ingredient_id)
        @grocery.save
      end
    end
    redirect_to action: "index"
  end

  def index
    @plan = Plan.new(user_id: current_user.id)
    @plans = Plan.where(user_id: current_user.id)
    @all_recipes = Recipe.pluck(:name).sort

    starting_date = Date.today
    @days = []
    0.upto(6) do |n|
      @days << ( starting_date + n.day )
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy

    if @plan.destroy
      @recipe = Recipe.find(@plan.recipe_id)
      @ingredients = @recipe.ingredients.pluck(:name)
      @ingredients.each do |x|
        ingredient_id = Ingredient.find_by(name: x).id
        @grocery = current_user.groceries.find_by_ingredient_id(ingredient_id)
        @grocery.destroy if @grocery
      end
    end

    redirect_to action: "index"
  end

  private
  def plan_params
    params.require(:plan).permit(:date, :recipe_id)
  end
end
