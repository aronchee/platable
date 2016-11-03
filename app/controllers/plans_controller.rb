class PlansController < ApplicationController
  def new
    @plan = Plan.new
    @plans = Plan.where(user_id: params[:user_id])
    @user = current_user
    @date = params[:date]

  end

  def create
    # byebug
    @plan = Plan.new(plan_params)
    @plan[:user_id] = params[:user_id]
    @plan.save

    redirect_to action: "index"

  end

  def index

    @plans = Plan.where(user_id: params[:user_id])

    @day1 = @plans.where(date: Date.today.strftime('%Y-%m-%d'))
    @day2= @plans.where(date: 1.days.since.strftime('%Y-%m-%d'))
    @day3= @plans.where(date: 2.days.since.strftime('%Y-%m-%d'))
    @day4= @plans.where(date: 3.days.since.strftime('%Y-%m-%d'))
    @day5= @plans.where(date: 4.days.since.strftime('%Y-%m-%d'))
    @day6= @plans.where(date: 5.days.since.strftime('%Y-%m-%d'))
    @day7= @plans.where(date: 6.days.since.strftime('%Y-%m-%d'))





  end

  def show
  end

  def edit
  end

  def update
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
