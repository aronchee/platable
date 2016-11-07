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

ActiveRecord::Schema.define(version: 20161104022914) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groceries", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "ingredient_id"
    t.boolean  "checked",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "ingredient_amounts", force: :cascade do |t|
    t.integer  "amount"
    t.string   "unit"
    t.integer  "ingredient_id"
    t.integer  "recipe_id"
    t.string   "remarks",       default: [],              array: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "ingredient_amounts", ["ingredient_id"], name: "index_ingredient_amounts_on_ingredient_id", using: :btree
  add_index "ingredient_amounts", ["recipe_id"], name: "index_ingredient_amounts_on_recipe_id", using: :btree

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nutrition_estimates", force: :cascade do |t|
    t.integer  "calories"
    t.float    "fat"
    t.float    "protein"
    t.integer  "cholesterol"
    t.integer  "sodium"
    t.float    "carbs"
    t.integer  "recipe_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "nutrition_estimates", ["recipe_id"], name: "index_nutrition_estimates_on_recipe_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "recipe_id"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "source"
    t.string   "name"
    t.string   "image"
    t.integer  "number_of_servings"
    t.text     "directions",         default: [],              array: true
    t.integer  "time_in_min"
    t.string   "ingredient_text",    default: [],              array: true
    t.string   "categories",         default: [],              array: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "ingredient_amounts", "ingredients"
  add_foreign_key "ingredient_amounts", "recipes"
  add_foreign_key "nutrition_estimates", "recipes"
end
