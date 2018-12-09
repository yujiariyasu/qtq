class ChangeColumnToReview < ActiveRecord::Migration[5.0]
  def change
    change_column :reviews, :proficiency, :integer, :default => 80
    add_column :reviews, :image, :string
  end
end
