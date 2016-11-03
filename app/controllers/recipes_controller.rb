class RecipesController < ApplicationController
  def index
  end

  def show
  end

  def cook
  end

  def search
  	params[:date] ||= []
  	@results = Listing.filter(search_filters)
    @similar = Listing.filter(similar_filters) unless @results.count > 5
  end

  private
  def search_filters
  	params.permit(:location, :capacity, :date => {}, :price => [], :room_type => [], :property_type => []).tap do |permitted|
			permitted[:location] = params[:location]
  		(permitted[:location].length).downto(0) { |i| permitted[:location] = permitted[:location].insert(i, "%")}
  		permitted[:price] = params_to_range(params[:price]) if params[:price].present?
  	end
  end

  def similar_filters
    search_filters.tap do |permitted|
			permitted[:price] = Range.new(permitted[:price].first.first.to_i/2, permitted[:price].last.last.to_i*1.25) if params[:price].present?
  		permitted[:capacity] = Range.new(params[:capacity].to_i-1, params[:capacity].to_i+2) if params[:capacity].present?
  	end
  end
end