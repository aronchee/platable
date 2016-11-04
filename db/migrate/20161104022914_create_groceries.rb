class CreateGroceries < ActiveRecord::Migration
  def change
    create_table :groceries do |t|
      t.integer :user_id
      t.integer :ingredient_id
      t.boolean :checked, :default => false

      t.timestamps null: false
    end
  end
end
