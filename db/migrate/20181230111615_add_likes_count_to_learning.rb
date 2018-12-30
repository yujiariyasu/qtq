class AddLikesCountToLearning < ActiveRecord::Migration[5.0]
  def change
    add_column :learnings, :likes_count, :integer
  end
end
