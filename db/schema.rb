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

ActiveRecord::Schema.define(version: 20150115164232) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",            null: false
    t.string   "uid",                 null: false
    t.string   "token"
    t.string   "secret"
    t.string   "access_token_digest"
    t.boolean  "expires"
    t.datetime "expires_at"
    t.json     "info"
    t.json     "extra"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "authentications", ["provider", "uid"], name: "index_authentications_on_provider_and_uid", unique: true, using: :btree
  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",             null: false
    t.string   "email",            null: false
    t.string   "username",         null: false
    t.string   "display_username", null: false
    t.string   "photo"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "string"
    t.string   "reset_digest"
    t.string   "reset_sent_at"
    t.string   "datetime"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "users", ["display_username"], name: "index_users_on_display_username", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "authentications", "users"
end
