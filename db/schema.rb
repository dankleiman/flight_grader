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

ActiveRecord::Schema.define(version: 20141002014057) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airports", force: true do |t|
    t.string   "code"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "name"
    t.integer  "market_id"
    t.string   "abbreviation"
  end

  create_table "carriers", force: true do |t|
    t.string   "code"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delay_causes", force: true do |t|
    t.string   "cause"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delays", force: true do |t|
    t.integer  "flight_id"
    t.integer  "delay_cause_id"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flights", force: true do |t|
    t.date     "flight_date"
    t.integer  "carrier_id"
    t.integer  "origin_airport_id"
    t.integer  "destination_airport_id"
    t.string   "cancellation_code"
    t.integer  "departure_delay"
    t.integer  "arrival_delay"
    t.integer  "distance_group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "markets", force: true do |t|
    t.string   "code"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
