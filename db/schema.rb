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

ActiveRecord::Schema.define(version: 20160906145649) do

  create_table "data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "sensor_type",                                     null: false
    t.decimal  "sensor_error",            precision: 3, scale: 2, null: false
    t.float    "sensor_data",  limit: 24,                         null: false
    t.datetime "log_time",                                        null: false
    t.integer  "device_id",                                       null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.float    "temperature",  limit: 24,                         null: false
    t.float    "pressure",     limit: 24,                         null: false
    t.float    "humidity",     limit: 24,                         null: false
    t.index ["device_id"], name: "index_data_on_device_id", using: :btree
  end

  create_table "devices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "device_id",   null: false
    t.integer  "device_type", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["device_id"], name: "index_devices_on_device_id", unique: true, using: :btree
  end

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "admin",      null: false
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin"], name: "fk_rails_85f52bec55", using: :btree
  end

  create_table "tokens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "token",      null: false
    t.datetime "expires"
    t.boolean  "enabled",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_tokens_on_token", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",            null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "session_token"
    t.integer  "group_id"
    t.index ["group_id"], name: "fk_rails_f40b3f4da6", using: :btree
    t.index ["session_token"], name: "fk_rails_5811ce5925", using: :btree
  end

  add_foreign_key "data", "devices"
  add_foreign_key "groups", "users", column: "admin"
  add_foreign_key "users", "groups"
  add_foreign_key "users", "tokens", column: "session_token"
end
