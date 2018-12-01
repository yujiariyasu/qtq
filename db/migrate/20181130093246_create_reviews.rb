class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.references :learning, foreign_key: true
      t.date :date

      t.timestamps
    end
  end
end
