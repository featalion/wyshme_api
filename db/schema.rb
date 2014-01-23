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

ActiveRecord::Schema.define(version: 20140120005736) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name",               null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "categories_items", id: false, force: true do |t|
    t.integer "category_id", null: false
    t.integer "item_id",     null: false
    t.boolean "featured"
  end

  add_index "categories_items", ["category_id"], name: "index_categories_items_on_category_id", using: :btree
  add_index "categories_items", ["item_id"], name: "index_categories_items_on_item_id", using: :btree

  create_table "events", force: true do |t|
    t.integer  "user_id"
    t.string   "name",        null: false
    t.date     "date"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events_lists", id: false, force: true do |t|
    t.integer "event_id", null: false
    t.integer "list_id",  null: false
  end

  add_index "events_lists", ["event_id"], name: "index_events_lists_on_event_id", using: :btree
  add_index "events_lists", ["list_id"], name: "index_events_lists_on_list_id", using: :btree

  create_table "item_likes", force: true do |t|
    t.integer "user_id"
    t.integer "item_id"
  end

  add_index "item_likes", ["item_id"], name: "index_item_likes_on_item_id", using: :btree
  add_index "item_likes", ["user_id"], name: "index_item_likes_on_user_id", using: :btree

  create_table "item_wyshes", force: true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_wyshes", ["item_id"], name: "index_item_wyshes_on_item_id", using: :btree
  add_index "item_wyshes", ["user_id"], name: "index_item_wyshes_on_user_id", using: :btree

  create_table "items", force: true do |t|
    t.string   "name",                                                    null: false
    t.text     "description"
    t.decimal  "price",              precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "url"
    t.string   "retailer"
    t.integer  "likes",                                       default: 0
    t.integer  "wyshes",                                      default: 0
  end

  create_table "items_lists", id: false, force: true do |t|
    t.integer "list_id", null: false
    t.integer "item_id", null: false
  end

  add_index "items_lists", ["item_id"], name: "index_items_lists_on_item_id", using: :btree
  add_index "items_lists", ["list_id"], name: "index_items_lists_on_list_id", using: :btree

  create_table "lists", force: true do |t|
    t.integer  "user_id"
    t.string   "name",        null: false
    t.text     "description"
    t.string   "event"
    t.date     "event_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public"
    t.boolean  "active"
    t.string   "item_order"
  end

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id",              null: false
    t.integer  "application_id",                 null: false
    t.string   "token",                          null: false
    t.integer  "expires_in",                     null: false
    t.string   "redirect_uri",      limit: 2048, null: false
    t.datetime "created_at",                     null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.string   "redirect_uri", limit: 2048, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
