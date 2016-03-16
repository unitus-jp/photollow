class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :book, index: true, foreign_key: true
      t.string :url
      t.binary :thumbnail
      t.string :title
      t.integer :order

      t.timestamps null: false
    end
  end
end
