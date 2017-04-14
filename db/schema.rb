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

ActiveRecord::Schema.define(version: 20170412054338) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "commenter"
    t.text     "body"
    t.integer  "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "item"
    t.integer  "user_id"
    t.boolean  "delivered"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "size"
  end

  create_table "racers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "race_count"
    t.integer  "longest_streak"
    t.integer  "current_streak"
    t.integer  "fav_bib"
  end

  create_table "races", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "state",      default: "false"
  end

  create_table "results", force: :cascade do |t|
    t.integer  "rank"
    t.integer  "bib"
    t.integer  "racer_id"
    t.string   "group_name"
    t.string   "time"
    t.integer  "race_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "results", ["race_id"], name: "index_results_on_race_id", using: :btree
  add_index "results", ["racer_id"], name: "index_results_on_racer_id", using: :btree

  create_table "start_items", force: :cascade do |t|
    t.integer  "racer_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "bib"
    t.integer  "race_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "finished",   default: false
    t.string   "group"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "strava_link"
    t.boolean  "admin"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "racer_id"
    t.string   "password_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "remember_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

end
