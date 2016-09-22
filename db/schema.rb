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

ActiveRecord::Schema.define(version: 20160921081502) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievment_types", force: :cascade do |t|
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "about"
  end

  create_table "achievments", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "achievment_type_id"
    t.date     "date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["achievment_type_id"], name: "index_achievments_on_achievment_type_id", using: :btree
    t.index ["team_id"], name: "index_achievments_on_team_id", using: :btree
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "game_registrations", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_registrations_on_game_id", using: :btree
    t.index ["team_id"], name: "index_game_registrations_on_team_id", using: :btree
  end

  create_table "games", force: :cascade do |t|
    t.string   "number"
    t.integer  "place_id"
    t.string   "name"
    t.integer  "league_id"
    t.integer  "price"
    t.datetime "when"
    t.string   "status",            default: "checking", null: false
    t.integer  "max_people_number"
    t.integer  "max_teams_number"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "main",              default: false,      null: false
    t.integer  "question_set"
    t.index ["league_id"], name: "index_games_on_league_id", using: :btree
    t.index ["place_id"], name: "index_games_on_place_id", using: :btree
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.integer  "inviter_id"
    t.string   "status",     default: "waiting", null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["team_id"], name: "index_invitations_on_team_id", using: :btree
    t.index ["user_id"], name: "index_invitations_on_user_id", using: :btree
  end

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
    t.string   "team_role"
    t.index ["team_id"], name: "index_members_on_team_id", using: :btree
    t.index ["user_id", "team_id"], name: "index_members_on_user_id_and_team_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "omnilinks", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_omnilinks_on_user_id", using: :btree
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "caption"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["game_id"], name: "index_photos_on_game_id", using: :btree
  end

  create_table "places", force: :cascade do |t|
    t.string   "name"
    t.string   "site"
    t.string   "address"
    t.integer  "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_places_on_city_id", using: :btree
  end

  create_table "team_ratings", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "game_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "round_one",   default: 0
    t.integer  "round_two",   default: 0
    t.integer  "round_three", default: 0
    t.integer  "round_four",  default: 0
    t.integer  "round_five",  default: 0
    t.integer  "round_six",   default: 0
    t.integer  "round_seven", default: 0
    t.integer  "max_score"
    t.index ["game_id"], name: "index_team_ratings_on_game_id", using: :btree
    t.index ["team_id"], name: "index_team_ratings_on_team_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "league_id"
    t.string   "invite"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "secret"
    t.index ["invite"], name: "index_teams_on_invite", unique: true, using: :btree
    t.index ["league_id"], name: "index_teams_on_league_id", using: :btree
    t.index ["name"], name: "index_teams_on_name", unique: true, using: :btree
  end

# Could not dump table "users" because of following StandardError
#   Unknown type 'role' for column 'role'

  add_foreign_key "achievments", "achievment_types"
  add_foreign_key "achievments", "teams"
  add_foreign_key "game_registrations", "games"
  add_foreign_key "game_registrations", "teams"
  add_foreign_key "games", "leagues"
  add_foreign_key "games", "places"
  add_foreign_key "invitations", "teams"
  add_foreign_key "invitations", "users"
  add_foreign_key "invitations", "users", column: "inviter_id"
  add_foreign_key "members", "teams"
  add_foreign_key "members", "users"
  add_foreign_key "omnilinks", "users"
  add_foreign_key "places", "cities"
  add_foreign_key "teams", "leagues"
  add_foreign_key "users", "cities"
end
