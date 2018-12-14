class AddPrivateFlagtoLearning < ActiveRecord::Migration[5.0]
  def change
    add_column :learnings, :public_flag, :boolean
  end
end
