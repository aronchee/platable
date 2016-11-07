class PlansController < ApplicationController
  def create
    @plan = current_user.plans.new(plan_params)
    @plan.recipe = Recipe.find_by_name(params[:recipe_name])
    @plan.save
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
    redirect_to action: "index"
  end

  private
  def plan_params
    params.require(:plan).permit(:date)
  end
end
