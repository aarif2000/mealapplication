class CreateActivePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :active_plans do |t|
      t.integer :user_id 
      t.integer :plan_id
      t.timestamps
    end
  end
end
