class RemoveFinishFlagFromLearning < ActiveRecord::Migration[5.0]
  def change
    remove_column :learnings, :finish_flag, :boolean
  end
end
