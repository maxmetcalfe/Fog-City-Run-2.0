# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_07_10_003238) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orders", id: :serial, force: :cascade do |t|
    t.string "item"
    t.integer "user_id"
    t.boolean "delivered"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "size"
  end

  create_table "racers", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "race_count"
    t.integer "longest_streak"
    t.integer "current_streak"
    t.integer "fav_bib"
    t.text "current_streak_array", default: [], array: true
    t.text "longest_streak_array", default: [], array: true
    t.text "count_data"
  end

  create_table "races", id: :serial, force: :cascade do |t|
    t.integer "race_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", default: "false"
    t.text "note"
  end

  create_table "results", id: :serial, force: :cascade do |t|
    t.integer "rank"
    t.integer "bib"
    t.integer "racer_id"
    t.string "group"
    t.string "time"
    t.string "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "race_id"
    t.string "group_name"
    t.index ["racer_id"], name: "index_results_on_racer_id"
  end

  create_table "start_items", id: :serial, force: :cascade do |t|
    t.integer "racer_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "bib"
    t.integer "race_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "finished", default: false
    t.string "group"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "strava_link"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "racer_id"
    t.string "password_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "remember_digest"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_foreign_key "results", "racers"
end
