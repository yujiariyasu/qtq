class AddFinishflagToLearning < ActiveRecord::Migration[5.0]
  def change
    add_column :learnings, :finish_flag, :boolean, default: false
  end
end
