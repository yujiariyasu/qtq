class AddCheckedToActivity < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :checked, :boolean, default: false
  end
end
