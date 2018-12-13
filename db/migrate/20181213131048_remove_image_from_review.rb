class RemoveImageFromReview < ActiveRecord::Migration[5.0]
  def change
    remove_column :reviews, :image, :string
  end
end
