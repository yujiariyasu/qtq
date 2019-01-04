class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true
      t.string :endpoint
      t.string :p256dh
      t.string :auth

      t.timestamps
    end
  end
end
