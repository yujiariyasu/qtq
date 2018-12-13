class RemoveDescriptionFromReview < ActiveRecord::Migration[5.0]
  def change
    remove_column :reviews, :description, :text
  end
end
