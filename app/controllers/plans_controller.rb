class PlansController < ApplicationController
  def new
    @plan = Plan.new
    @plans = Plan.where(user_id: params[:user_id])
    @user = current_user
    @date = params[:date]
  end

  def create

    @plan = Plan.new(plan_params)
    @plan[:user_id] = params[:user_id]
    @plan.save

    redirect_to action: "index"

  end

  def index

    @plans = Plan.where(user_id: params[:user_id])

    @day1 = @plans.where(date: Date.today.strftime('%Y-%m-%d'))

  end

  def show
  end


  def destroy

    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_to action: "index"
  end

  private
    def plan_params
      params.require(:plan).permit(:recipe_id, :date)
    end
end
