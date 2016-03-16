class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :book, index: true, foreign_key: true
      t.string :url, null: false
      t.binary :thumbnail
      t.string :title, null: false
      t.integer :order, null: false

      t.timestamps null: false
    end
  end
end
