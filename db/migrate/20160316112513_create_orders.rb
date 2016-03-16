class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :number, null: false
      t.references :page, index: true, foreign_key: true
      t.references :image, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
