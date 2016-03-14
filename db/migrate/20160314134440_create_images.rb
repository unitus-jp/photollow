class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :url
      t.references :page, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
