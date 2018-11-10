class CreateUserRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :user_relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :user_relationships, :follower_id
    add_index :user_relationships, :followed_id
    add_index :user_relationships, [:follower_id, :followed_id], unique: true  end
end
