class Ingredient < ActiveRecord::Base
	has_many :ingredient_amounts, dependent: :destroy
	has_many :recipes, through: :ingredient_amounts
end
