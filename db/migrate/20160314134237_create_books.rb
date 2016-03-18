class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :name, null: false
      t.string :title, null: false
      t.binary :thumbnail, null: false
      t.text :description

      t.timestamps null: false
    end
    add_index :books, :name, :unique => true
  end
end
