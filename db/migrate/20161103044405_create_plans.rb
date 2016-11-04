class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :user_id, index: true
      t.integer :recipe_id, index: true
      t.date :date

      t.timestamps null: false
    end
  end
end
