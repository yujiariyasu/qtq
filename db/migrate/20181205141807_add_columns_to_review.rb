class AddColumnsToReview < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :proficiency, :integer
    add_column :reviews, :description, :string
    remove_column :reviews, :date, :date
  end
end
