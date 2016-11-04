class CreateNutritionEstimates < ActiveRecord::Migration
  def change
    create_table :nutrition_estimates do |t|
      t.integer :calories
      t.float :fat, precision: 4, scale: 1
      t.float :protein, precision: 4, scale: 1
      t.integer :cholesterol
      t.integer :sodium
      t.float :carbs, precision: 4, scale: 1
      t.belongs_to :recipe, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
