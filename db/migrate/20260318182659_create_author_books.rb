class CreateAuthorBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :author_books do |t|
      t.references :book, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
