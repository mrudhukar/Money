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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110917090704) do

  create_table "common_items", :force => true do |t|
    t.integer  "group_user_id"
    t.string   "name"
    t.string   "description"
    t.integer  "cost",             :default => 0
    t.date     "transaction_date"
    t.integer  "transaction_type", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "common_items", ["group_user_id"], :name => "index_common_items_on_group_user_id"

  create_table "group_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.float    "balance",    :default => 0.0
    t.integer  "status",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_users", ["user_id", "group_id"], :name => "index_group_users_on_user_id_and_group_id"

  create_table "groups", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.string   "code"
    t.datetime "redeemed_at"
    t.integer  "redeemed_by_id"
    t.datetime "expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "common_item_id"
    t.integer  "user_id",                       :null => false
    t.integer  "default_amount", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["user_id", "common_item_id"], :name => "index_items_on_user_id_and_common_item_id"

  create_table "users", :force => true do |t|
    t.string   "name",                                  :null => false
    t.string   "email",                                 :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                     :null => false
    t.string   "perishable_token",   :default => "",    :null => false
    t.integer  "login_count",        :default => 0,     :null => false
    t.integer  "failed_login_count", :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.integer  "net_balance",        :default => 0
    t.string   "nick_name"
    t.boolean  "app_admin",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
