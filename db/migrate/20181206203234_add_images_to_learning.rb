class AddImagesToLearning < ActiveRecord::Migration[5.0]
  def change
    add_column :learnings, :images, :string, array: true, default: [].to_yaml
  end
end
