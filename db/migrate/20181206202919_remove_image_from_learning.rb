class RemoveImageFromLearning < ActiveRecord::Migration[5.0]
  def change
    remove_column :learnings, :image, :string
  end
end
