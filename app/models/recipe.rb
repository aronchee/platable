class Recipe < ActiveRecord::Base
	has_one :nutrition_estimate
	has_many :ingredient_amounts, dependent: :destroy
	has_many :ingredients, through: :ingredient_amounts

	validates :name, uniqueness: true

	include Filterable

	scope :ingredient, -> (array) { joins(:ingredients).where("ingredients.name ILIKE ANY ( array[?])", array.map { |x| "%#{x}%" }).group("recipes.id").order(count: :desc) }
	scope :simple, -> { order("cardinality(ingredient_text)") }
	scope :cuisine, -> (type) { where("categories @> ?", "{#{type}}") }
	scope :category, -> (type) { where("categories @> ?", "{#{type}}") }
	scope :main, -> (type) { where("categories @> ?", "{#{type}}") }
	scope :time, -> (range) { where(time_in_min: range).order(:time_in_min) }
	scope :nutrition, -> (array) { joins(:nutrition_estimate).where("#{array}") }
	# exclusions
	scope :dairy, -> (bool) { where.not(ingredients: {name: ["milk", "cheese", "cream", "custard", "yogurt", "pudding"] }) }
	scope :eggs, -> (bool) { where.not(ingredients: {name: "egg"}) }
	scope :peanuts, -> (bool) { where.not(ingredients: {name: "peanut"}) }
	scope :nuts, -> (bool) { where.not(ingredients: {name: "nut"}) }
	scope :soy, -> (bool) { where.not(ingredients: {name: "soy"}) }
	scope :gluten, -> (bool) { where.not(ingredients: {name: ["oats", "flour"]}) }
	scope :seafood, -> (bool) { where.not("categories @> ?", "{Seafood}") }
	scope :vegetarian, -> (bool) { where.not("categories @> '{Meat and Poultry}' OR categories @> '{Seafood}'") }
	scope :spicy, -> (bool) { where.not("categories @> '{Spicy}'").where.not("ingredients.name LIKE '%chili%'") }

	EXCLUSION = ["dairy", "eggs", "peanuts", "nuts", "soy", "gluten", "seafood", "spicy", "vegetarian"]
	PREP_TIME = {"< 30 min" => "0-30", "30 min - 1 hr" => "30-60", "1 - 2 hr" => "60-120", "2 - 3 hr" => "120-180", "> 3 hr" => "180-1000"}
	CUISINE = ["Latin American", "American", "European", "Eastern European", "Asian"]
	CATEGORY = ["Appetizers and Snacks", "Main Dish", "Side Dish", "Desserts", "Healthy", "Quick and Easy"]
	MAIN_INGREDIENT = ["Meat and Poultry", "Seafood", "Vegetable", "Fruit"]
end
