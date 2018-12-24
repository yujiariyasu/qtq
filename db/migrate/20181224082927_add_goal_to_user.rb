class AddGoalToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :goal, :integer, dafault: 10
  end
end
