class RemovePublicFlagFromLearning < ActiveRecord::Migration[5.0]
  def change
    remove_column :learnings, :public_flag, :boolean
  end
end
