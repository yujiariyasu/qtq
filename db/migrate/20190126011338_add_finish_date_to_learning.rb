class AddFinishDateToLearning < ActiveRecord::Migration[5.0]
  def change
    add_column :learnings, :finish_date, :date
  end
end
