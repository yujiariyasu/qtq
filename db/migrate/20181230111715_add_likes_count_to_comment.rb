class AddLikesCountToComment < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :likes_count, :integer
  end
end
