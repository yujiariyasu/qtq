class AddPushedToActivity < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :pushed, :boolean, default: false
  end
end
