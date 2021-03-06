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

ActiveRecord::Schema.define(version: 2020_07_18_135101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "market_products", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "market_id"
    t.index ["market_id"], name: "index_market_products_on_market_id"
    t.index ["product_id"], name: "index_market_products_on_product_id"
  end

  create_table "markets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "fmid"
    t.string "marketname"
    t.string "website"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "season1date"
    t.string "season1time"
    t.string "season2date"
    t.string "season2time"
    t.float "latitude"
    t.float "longitude"
  end

  create_table "products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  add_foreign_key "market_products", "markets"
  add_foreign_key "market_products", "products"
end
