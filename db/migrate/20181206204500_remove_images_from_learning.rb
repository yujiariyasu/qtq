class RemoveImagesFromLearning < ActiveRecord::Migration[5.0]
  def change
    remove_column :learnings, :images, :string
  end
end
