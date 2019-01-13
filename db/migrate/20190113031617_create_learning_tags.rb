class CreateLearningTags < ActiveRecord::Migration[5.0]
  def change
    create_table :learning_tags do |t|
      t.references :learning, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
    add_index :learning_tags, [:learning_id,:tag_id],unique: true
  end
end
