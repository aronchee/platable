# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# seed recipe
files = ["appetizers-and-snacks", "desserts", "everyday-cooking", "main-dish"]

files.each do |file_name|
	@input_file = "db/raw_recipes/recipes-#{file_name}.txt"

	array = File.read(@input_file).split("\n")

	array.each do |recipe|
		recipe_hash = eval(recipe)
		nutrition_estimates = recipe_hash.delete("nutrition_estimates")
		text_ingredient = recipe_hash.delete("ingredients")
		@recipe = Recipe.create(recipe_hash)
		@recipe.update(ingredient_text: text_ingredient)

		if nutrition_estimates != {}
			NutritionEstimate.create do |x|
				x.calories = nutrition_estimates["calories"][:value]
				x.fat = nutrition_estimates["fat "][:value]
				x.carbs = nutrition_estimates["carbs "][:value]
				x.protein = nutrition_estimates["protein "][:value]
				x.cholesterol = nutrition_estimates["cholesterol "][:value]
				x.sodium = nutrition_estimates["sodium "][:value]
				x.recipe_id = @recipe.id
			end
		end
	end
end


# # ingredients
amount = ["fluid ounce", "quart", "bunch", "medium", "small", "piece", "tablespoon", "cup", "ounce", "teaspoon", "can", "pound", "package", "large", "clove", "container", "bottle", "whole", "pinch", "jar", "cube", "loaf", "slice"]


instruction = ["liquid", "-inch", "strips", "sifted", "coarsely", "decoration", "boiling", "wedges", "packet", "half", "thick", "chunks", "stalk", "uncooked", "extra lean", "halved", "flaked", "warm", "pounded", "removed", "refrigerated", "frying", "rinsed", "deveined", "canned", "degrees", "seasoned", "cubed", "flakes", "thinly", "cooked", "seeded", "cored", "freshly", "prepared", "juiced", "thawed", "divided", "finely", "optional", "crushed", "melted", "frozen", "peeled", "cut", "dry", "inch", "halves", "grated", "sliced", "skinless", "boneless", "dried", "minced", "softened", "chopped", "beaten", "diced", "drained", "ground", "fresh"]

Recipe.all.each do |recipe|
	@ingredients_list = recipe.ingredient_text

	@ingredients_list.each do |ing|
		ing1 = ing.tr("/","")
		remark = []

		@amount = recipe.ingredient_amounts.new

		if ing1.include?(",")
			temp_array = ing1.split(', ')
			ing1 = temp_array.shift
			remark << temp_array
		end
		
		temp_array = ing1.split(' ')
		instruction.each do |i|
			remark << temp_array.delete(i)
		end
		ing1 = temp_array.join(" ")

		remark << ing1.scan(/\(\d.+\)/)[0]
		ing1.gsub!(/\(\d.+\) ?/, "")
		@amount.amount = ing1.scan(/\d+/)[0]
		ing1.gsub!(/\d+ ?/, "")

		temp_array = ing1.split(' ')
		amount.each do |a|
			if temp_array.include?(a) || temp_array.include?(a.pluralize)
				@amount.unit = a
				temp_array.delete(a.pluralize)
				temp_array.delete(a)
			end
		end
		ing1 = temp_array.join(" ")

		@amount.remarks = remark.flatten.compact!

		@amount.ingredient = Ingredient.find_or_create_by(name: ing1.strip)
		

		@amount.save
	end

end