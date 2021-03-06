# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160317080250) do

  create_table "books", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "title",       null: false
    t.binary   "thumbnail"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "books", ["name"], name: "index_books_on_name", unique: true

  create_table "images", force: :cascade do |t|
    t.binary   "data",        null: false
    t.string   "hashed_data", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "images", ["hashed_data"], name: "index_images_on_hashed_data", unique: true

  create_table "orders", force: :cascade do |t|
    t.integer  "number",     null: false
    t.string   "image_id",   null: false
    t.integer  "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "orders", ["image_id"], name: "index_orders_on_image_id"
  add_index "orders", ["page_id"], name: "index_orders_on_page_id"

  create_table "pages", force: :cascade do |t|
    t.string   "book_id",    null: false
    t.string   "url",        null: false
    t.binary   "thumbnail"
    t.string   "title",      null: false
    t.integer  "order",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "pages", ["book_id"], name: "index_pages_on_book_id"

  create_table "shelves", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
