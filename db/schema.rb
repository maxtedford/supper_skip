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

ActiveRecord::Schema.define(version: 20150716000908) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_id"
  end

  add_index "categories", ["restaurant_id"], name: "index_categories_on_restaurant_id", using: :btree

  create_table "item_categories", force: true do |t|
    t.integer "item_id"
    t.integer "category_id"
  end

  create_table "items", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "retired",            default: false
    t.integer  "restaurant_id"
    t.integer  "prep_time",          default: 12
  end

  add_index "items", ["restaurant_id"], name: "index_items_on_restaurant_id", using: :btree
  add_index "items", ["title"], name: "index_items_on_title", unique: true, using: :btree

  create_table "order_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_id"
    t.integer  "restaurant_order_id"
  end

  add_index "order_items", ["restaurant_id"], name: "index_order_items_on_restaurant_id", using: :btree
  add_index "order_items", ["restaurant_order_id"], name: "index_order_items_on_restaurant_order_id", using: :btree

  create_table "orders", force: true do |t|
    t.boolean  "delivery"
    t.string   "address"
    t.string   "status",     default: "in_cart"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "total"
  end

  create_table "permissions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurant_orders", force: true do |t|
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",        default: 0
    t.integer  "order_id"
    t.integer  "staff_id"
  end

  add_index "restaurant_orders", ["order_id"], name: "index_restaurant_orders_on_order_id", using: :btree
  add_index "restaurant_orders", ["restaurant_id"], name: "index_restaurant_orders_on_restaurant_id", using: :btree

  create_table "restaurants", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles", force: true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["restaurant_id"], name: "index_user_roles_on_restaurant_id", using: :btree
  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email_address"
    t.string   "name"
    t.string   "display_name"
    t.string   "password_digest"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email_address"], name: "index_users_on_email_address", unique: true, using: :btree

end
