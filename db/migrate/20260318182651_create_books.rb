class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :first_publish_year
      t.string :cover_url
      t.string :ol_key
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end
  end
end
