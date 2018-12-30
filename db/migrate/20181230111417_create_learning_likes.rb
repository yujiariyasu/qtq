class CreateLearningLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :learning_likes do |t|
      t.references :user, foreign_key: true
      t.references :learning, foreign_key: true

      t.timestamps
    end
  end
end
