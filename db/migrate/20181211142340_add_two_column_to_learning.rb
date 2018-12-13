class AddTwoColumnToLearning < ActiveRecord::Migration[5.0]
  def change
    add_column :learnings, :proficiency_decrease_speed, :int
    add_column :learnings, :next_review_date, :date
  end
end
