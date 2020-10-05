# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_04_154301) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "item_suppliers", force: :cascade do |t|
    t.bigint "item_id"
    t.string "url"
    t.integer "priority"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_item_suppliers_on_item_id"
  end

  create_table "item_variations", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.integer "base_id", null: false
    t.string "text"
    t.integer "stock"
    t.string "key"
    t.string "barcode"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_item_variations_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.string "key"
    t.string "name"
    t.string "detail"
    t.integer "price"
    t.integer "proper_price"
    t.integer "tax_type"
    t.integer "stock"
    t.integer "visible"
    t.integer "display_order"
    t.string "images", array: true
    t.datetime "modified_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shop_id"], name: "index_items_on_shop_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.string "key"
    t.datetime "ordered_at"
    t.datetime "cancelled_at"
    t.datetime "dispatched_at"
    t.integer "payment"
    t.string "first_name"
    t.string "last_name"
    t.integer "price"
    t.date "delivery_date"
    t.integer "status"
    t.datetime "modified_at"
    t.string "subscription_key"
    t.integer "subscription_repeat_number"
    t.integer "subscription_repeat_times"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "shipping_method"
    t.integer "shipping_fee"
    t.integer "cod_fee"
    t.string "country"
    t.string "zip_code"
    t.string "prefecture"
    t.string "address"
    t.string "address2"
    t.string "email"
    t.string "tel"
    t.string "remark"
    t.string "comment"
    t.integer "delivery_company_id"
    t.string "delivery_time_zone"
    t.string "tracking_number"
    t.string "receiver_first_name"
    t.string "receiver_last_name"
    t.string "receiver_zipcode"
    t.string "receiver_prefecture"
    t.string "receiver_address"
    t.string "receiver_address2"
    t.string "receiver_tel"
    t.string "receiver_country"
    t.text "balance_logs", array: true
    t.index ["shop_id"], name: "index_orders_on_shop_id"
  end

  create_table "shop_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "shop_id", null: false
    t.integer "role", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shop_id"], name: "index_shop_users_on_shop_id"
    t.index ["user_id"], name: "index_shop_users_on_user_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "base_id", null: false
    t.string "name", null: false
    t.string "introduction"
    t.string "url"
    t.string "logo"
    t.string "email"
    t.string "base_access_token"
    t.datetime "base_access_token_expires_at"
    t.string "base_refresh_token"
    t.datetime "base_refresh_token_expires_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "order_updated_at"
    t.datetime "item_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.integer "term"
    t.string "line_name"
    t.string "facebook_name"
    t.datetime "approved_at"
    t.bigint "approved_by_id"
    t.integer "role", null: false
    t.integer "status", default: 1
    t.index ["approved_by_id"], name: "index_users_on_approved_by_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "item_suppliers", "items"
  add_foreign_key "item_variations", "items"
  add_foreign_key "items", "shops"
  add_foreign_key "orders", "shops"
  add_foreign_key "shop_users", "shops"
  add_foreign_key "shop_users", "users"
  add_foreign_key "users", "users", column: "approved_by_id"
end
