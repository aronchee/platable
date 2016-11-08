# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# # recipe
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

Recipe.where(time_in_min: 0).each { |x| x.update(time_in_min: nil) }
Recipe.where(time_in_min: 1).each { |x| x.update(time_in_min: 60) }
Recipe.where(time_in_min: 2).each { |x| x.update(time_in_min: 120) }
Recipe.where(time_in_min: 3).each { |x| x.update(time_in_min: 180) }
Recipe.where(time_in_min: 4).each { |x| x.update(time_in_min: 240) }
Recipe.where(time_in_min: 5).last.update(time_in_min: 300)


# # ingredients
amount = ["ounce", "quart", "bunch", "medium", "small", "piece", "tablespoon", "cup", "ounce", "teaspoon", "can", "pound", "package", "large", "clove", "container", "bottle", "whole", "pinch", "jar", "cube", "loaf", "slice", "bag", "sprig", "stalk", "head", "dash", "individual", "box", "bar"]


instruction = ["liquid", "-inch", "strips", "sifted", "coarsely", "decoration", "boiling", "wedges", "packet", "half", "thick", "chunks", "stalk", "uncooked", "extra lean", "halved", "flaked", "warm", "pounded", "removed", "refrigerated", "frying", "rinsed", "deveined", "canned", "degrees", "seasoned", "cubed", "flakes", "thinly", "cooked", "seeded", "cored", "freshly", "prepared", "juiced", "thawed", "divided", "finely", "optional", "crushed", "melted", "frozen", "peeled", "cut", "dry", "inch", "halves", "grated", "sliced", "skinless", "boneless", "dried", "minced", "softened", "chopped", "beaten", "diced", "drained", "ground", "fresh", "bone-in", "shredded", "snipped", "coating", "crumbled", "extra", "lean", "light", "as", "needed", "recipe", "unbleached", "all-purpose", "jumbo", "low-fat", "mashed", "Italian", "Dijon", "Dijon-style", "Italian-seasoned", "Italian-style", "ripe", "roasted", "sharp", "slivered", "teriyaki sauce", "unsalted", "unbaked", "unsweetened", "unpopped", "cold", "coarse-ground", "distilled", "extra-virgin", "oil-packed"]

Recipe.all.each do |recipe|
	@ingredients_list = recipe.ingredient_text

	@ingredients_list.each do |ing|
		break if ing.include?(":")
		ing1 = ing.tr("/","")
		ing1.sub!("to taste", "")
		remark = []

		amount_temp = recipe.ingredient_amounts.new

		if ing1.include?(",")
			temp_array = ing1.split(', ')
			ing1 = temp_array.shift
			remark << temp_array
		end

		if ing1.include?(";")
			temp_array = ing1.split('; ')
			ing1 = temp_array.shift
			remark << temp_array
		end

		if ing1.include?("for ")
			ing1.scan(/for .+$/).each { |y| remark << y }
			ing1.gsub!(/for .+$/, "")
		end
		
		temp_array = ing1.split(' ')
		temp_array -= ["-", "McCormick®", "and", "to", "taste", "your", "favorite", "for", "a", "or"]
		instruction.each do |i|
			remark << temp_array.delete(i)
		end
		ing1 = temp_array.join(" ")

		ing1.scan(/\(.+\)/).each { |y| remark << y }
		ing1.gsub!(/\(.+\)/, "")
		amount_temp["amount"] = ing1.scan(/\d+/)[0]
		ing1.gsub!(/\d+ ?/, "")

		temp_array = ing1.split(' ')
		temp_array.delete_if { |x| x.upcase == x }
		if temp_array.include?("fluid") && temp_array.include?("ounce") || temp_array.include?("ounces")
			amount_temp["unit"] = "fluid ounce"
			temp_array.delete("fluid")
			temp_array.delete("ounce")
			temp_array.delete("ounces")
		else
			amount.each do |a|
				if temp_array.include?(a) || temp_array.include?(a.pluralize)
					amount_temp["unit"] = a
					temp_array.delete(a.pluralize)
					temp_array.delete(a)
				end
			end
		end
		ing1 = temp_array.join(" ")

		ing2 = ing1.strip.downcase.singularize
		if ing2.include?("olife")
			ing2.gsub!("olife", "olive")
		elsif ing2.include?("leafe")
			ing2.gsub!("leafe", "leaf")
		elsif ing2.include?("pastum")
			ing2.gsub!("pastum", "pasta")
		elsif ing2.include?("fetum")
			ing2.gsub!("fetum", "feta")
		elsif ing2.include?("cooky")
			ing2.gsub!("cooky", "cookie")		
		elsif ing2.include?("preserf")
			ing2.gsub!("preserf", "preserve")		
		elsif ing2.include?("chily")
			ing2.gsub!("chily", "chili")		
		elsif ing2.include?("lettuce")
			ing2 = "lettuce"
		elsif ing2.include?("yeast")
			ing2 = "yeast"
		elsif ing2.include?("mustard")
			ing2 = "mustard"
		elsif ing2.include?("half-and-half")
			ing2 = "half-and-half cream"			
		elsif ing2.include?("cheddar-monterey") || ing2.include?("cheddarmonterey")
			ing2 = "cheddar cheese"		
		elsif ing2.include?("colby-monterey")
			ing2 = "colby cheese"
		elsif ing2.include?("vanilla extract")
			ing2 = "vanilla extract"
		end
		ingredient_id = Ingredient.find_or_create_by(name: ing2).id

		@amount = IngredientAmount.find_or_initialize_by(recipe_id: recipe.id, ingredient_id: ingredient_id)
		if @amount.new_record?
			@amount.amount = amount_temp["amount"]
			@amount.remarks = remark.flatten.compact!
			@amount.unit = amount_temp["unit"]
		else
			if @amount.amount
				@amount.amount += amount_temp["amount"].to_i
			else
				@amount.amount = amount_temp["amount"]
			end
			@amount.remarks += remark.flatten.compact!
		end
		@amount.save
	end
end

Ingredient.find_by_name("toothpick").destroy
Ingredient.find_by_name("skewer").destroy
Ingredient.find_by_name("").destroy

grocery_list = [
	["Night Market", "Jalan Tun Mohd Fuad 3", 3.141013, 101.627102],
	["Ben's Grocery", "Glo Damansara, Jalan Damansara", 3.132962, 101.629875],
	["AEON Big Tropicana Mall", "Jalan SS 20/27", 3.130819, 101.626828],
	["Village Grocer", "Damansara Jaya", 3.127161, 101.616543],
	["Hero Supermarket", "TTDI Plaza, Jalan Wan Kadir", 3.136879, 101.631187],
	["Kedai Runcit Kian Huat", "Jalan SS22/11", 3.131165, 101.621165],
	["Kedai Rakyat Malaysia", "Damansara Utama Uptown", 3.134046, 101.620957],
	["Gan Mini Market", "Damansara Utama Uptown", 3.134552, 101.625734],
	["Soon Thye Hang", "Glo Damansara, Jalan Damansara", 3.132464, 101.629972],
	["1 Utama Megamall", "", 3.150862, 101.614665]
]

grocery_list.each do |title, address, latitude, longitude|
	Map.create(title: title, address: address, latitude: latitude, longitude: longitude)
end