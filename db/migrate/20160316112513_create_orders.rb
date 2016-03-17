class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :number, null: false
      t.string :image_id, null: false, index: true, foreign_key: true
      t.references :page, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
