class AddProficiencyToLearning < ActiveRecord::Migration[5.0]
  def change
    add_column :learnings, :proficiency, :integer
  end
end
