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

ActiveRecord::Schema.define(version: 20160905150835) do

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

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",            null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "data", "devices"
end
