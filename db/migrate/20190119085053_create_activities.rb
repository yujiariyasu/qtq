class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.integer :active_user_id
      t.integer :passive_user_id
      t.integer :learning_id
      t.string :type

      t.timestamps
    end
    add_index :activities, :active_user_id
    add_index :activities, :passive_user_id
    add_index :activities, :learning_id
  end
end
