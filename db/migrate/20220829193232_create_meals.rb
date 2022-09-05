class CreateMeals < ActiveRecord::Migration[7.0]
  def change
    create_table :meals do |t|
      t.integer :day_id 
      t.integer :meal_category_id 
      t.integer :recipe_id 
      t.timestamps
    end
  end
end
