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

ActiveRecord::Schema.define(version: 20170508130643) do

  create_table "data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "device_id",              null: false
    t.integer  "sensor_type",            null: false
    t.datetime "log_time",               null: false
    t.integer  "gas",                    null: false
    t.float    "conc_ppm",    limit: 24
    t.float    "conc_ugm3",   limit: 24
    t.index ["device_id", "sensor_type", "log_time", "gas"], name: "index_data_on_device_id_and_sensor_type_and_log_time_and_gas", unique: true, using: :btree
  end

  create_table "devices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "identity",    null: false
    t.integer  "device_type", null: false
    t.string   "token"
    t.integer  "group_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["group_id"], name: "fk_rails_fda8e2d312", using: :btree
    t.index ["identity"], name: "index_devices_on_identity", unique: true, using: :btree
    t.index ["token"], name: "index_devices_on_token", unique: true, using: :btree
  end

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "admin",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin"], name: "index_groups_on_admin", unique: true, using: :btree
  end

  create_table "raw_data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "device_id",               null: false
    t.integer  "sensor_type",             null: false
    t.float    "sensor_error", limit: 24, null: false
    t.integer  "sensor_data",             null: false
    t.datetime "log_time",                null: false
    t.float    "temperature",  limit: 24, null: false
    t.float    "pressure",     limit: 24, null: false
    t.float    "humidity",     limit: 24, null: false
    t.float    "sensor_r0",    limit: 24
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["device_id", "sensor_type", "log_time"], name: "index_raw_data_on_device_id_and_sensor_type_and_log_time", unique: true, using: :btree
    t.index ["device_id"], name: "index_raw_data_on_device_id", using: :btree
  end

  create_table "tokens", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "token",                     null: false
    t.datetime "expires"
    t.boolean  "enabled",    default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["token"], name: "index_tokens_on_token", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                           null: false
    t.string   "name",                            null: false
    t.string   "password_digest",                 null: false
    t.boolean  "staff",           default: false, null: false
    t.string   "session_token"
    t.string   "confirm_token"
    t.string   "reset_token"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "group_id"
    t.index ["confirm_token"], name: "index_users_on_confirm_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["group_id"], name: "fk_rails_f40b3f4da6", using: :btree
    t.index ["reset_token"], name: "index_users_on_reset_token", unique: true, using: :btree
    t.index ["session_token"], name: "index_users_on_session_token", unique: true, using: :btree
  end

  add_foreign_key "data", "devices"
  add_foreign_key "devices", "groups"
  add_foreign_key "devices", "tokens", column: "token", primary_key: "token"
  add_foreign_key "groups", "users", column: "admin"
  add_foreign_key "raw_data", "devices"
  add_foreign_key "users", "groups"
  add_foreign_key "users", "tokens", column: "confirm_token", primary_key: "token"
  add_foreign_key "users", "tokens", column: "reset_token", primary_key: "token"
  add_foreign_key "users", "tokens", column: "session_token", primary_key: "token"
end
