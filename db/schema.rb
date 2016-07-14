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

ActiveRecord::Schema.define(version: 20160714160654) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "leagues", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_leagues_on_name", unique: true, using: :btree
  end

  create_table "members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_members_on_team_id", using: :btree
    t.index ["user_id", "team_id"], name: "index_members_on_user_id_and_team_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "league_id"
    t.string   "invite"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invite"], name: "index_teams_on_invite", unique: true, using: :btree
    t.index ["league_id"], name: "index_teams_on_league_id", using: :btree
    t.index ["name"], name: "index_teams_on_name", unique: true, using: :btree
  end

# Could not dump table "users" because of following StandardError
#   Unknown type 'role' for column 'role'

  add_foreign_key "members", "teams"
  add_foreign_key "members", "users"
  add_foreign_key "teams", "leagues"
end
