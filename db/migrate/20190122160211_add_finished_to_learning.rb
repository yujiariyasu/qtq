class AddFinishedToLearning < ActiveRecord::Migration[5.0]
  def change
    add_column :learnings, :finished, :boolean, default: false
  end
end
