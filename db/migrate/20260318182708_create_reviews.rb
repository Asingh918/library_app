class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.text :body
      t.string :reviewer_name
      t.integer :score
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
