class AddTimeToLearning < ActiveRecord::Migration[5.0]
  def change
    add_column :learnings, :study_time, :int
  end
end
