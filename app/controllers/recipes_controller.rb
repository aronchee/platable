class RecipesController < ApplicationController
  def index
  end

  def show
  end

  def cook
    if params[:id]
      @recipe = Recipe.find(params[:id]) if params[:id]
      @directions = @recipe.directions.map { |x| x.split('.') }
      @steps = @directions.length - 1
    else
      @all_recipes = Recipe.pluck(:name).sort
    end
    respond_to do |format|
      format.html
      format.js
    end    
  end

  def search_by_name
    recipe_id = Recipe.find_by_name(params[:name]).id
    redirect_to "/recipes/#{recipe_id}/cook"
  end

  def search
    @plan = Plan.new
  	params[:ingredient] ||= []
    params[:filter] ||= {}
    @all_ingredients = Ingredient.pluck(:name).sort
    @results = Recipe.ingredient(params[:ingredient].reject(&:empty?)).filter(search_filters).simple
    respond_to do |format|
      format.html
      format.js
    end
  end

  private
  def search_filters
  	params.permit(:dairy, :eggs, :peanuts, :nuts, :soy, :gluten, :seafood, :vegetarian, :spicy, :cuisine, :category, :main, :time).tap do |permitted|
      strings = []
      params[:filter].each do |k, v| 
        strings << k
        strings << v
        strings << "AND"
      end
      strings.pop
      string = strings.join(" ")
      permitted[:nutrition] = string
  	end
  end
end