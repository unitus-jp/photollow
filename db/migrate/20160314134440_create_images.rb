class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.binary :data, null: false
      t.string :hashed_data, null: false

      t.timestamps null: false
    end
    add_index :images, :hashed_data, :unique => true
  end
end
