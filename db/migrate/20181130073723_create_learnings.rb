class CreateLearnings < ActiveRecord::Migration[5.0]
  def change
    create_table :learnings do |t|
      t.string :title
      t.text :description
      t.string :image
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
