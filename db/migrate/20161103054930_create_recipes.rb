class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :source
      t.string :name
      t.string :image
      t.integer :number_of_servings
      t.text :directions, array: true, default: []
      t.integer :time_in_min
      t.string :ingredient_text, array: true, default: []
      t.string :categories, array: true, default: []

      t.timestamps null: false
    end
  end
end
