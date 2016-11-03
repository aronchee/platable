class CreateIngredientAmounts < ActiveRecord::Migration
  def change
    create_table :ingredient_amounts do |t|
      t.integer :amount
      t.string :unit
      t.references :ingredient, index: true, foreign_key: true
      t.references :recipe, index: true, foreign_key: true
      t.string :remarks, array: true, default: []

      t.timestamps null: false
    end
  end
end
