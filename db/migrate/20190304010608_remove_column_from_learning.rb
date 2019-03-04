class RemoveColumnFromLearning < ActiveRecord::Migration[5.0]
  def change
    remove_column :learnings, :proficiency_decrease_speed, :integer
  end
end
