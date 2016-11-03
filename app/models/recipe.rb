class Recipe < ActiveRecord::Base
	has_one :nutrition_estimate
	has_many :ingredient_amounts
	has_many :ingredients, through: :ingredient_amounts

	validates :name, uniqueness: true
end
