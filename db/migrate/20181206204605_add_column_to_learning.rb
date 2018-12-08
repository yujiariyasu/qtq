class AddColumnToLearning < ActiveRecord::Migration[5.0]
  def change
    add_column :learnings, :images, :json
  end
end
