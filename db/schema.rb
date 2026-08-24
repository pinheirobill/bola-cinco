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

ActiveRecord::Schema[8.1].define(version: 2026_08_24_234500) do
  create_table "athletes", force: :cascade do |t|
    t.date "birth_date"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.string "document"
    t.string "name", null: false
    t.string "shirt_number"
    t.string "source_id", null: false
    t.string "status", default: "pendente", null: false
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_athletes_on_category_id"
    t.index ["source_id"], name: "index_athletes_on_source_id", unique: true
    t.index ["team_id", "status"], name: "index_athletes_on_team_id_and_status"
    t.index ["team_id"], name: "index_athletes_on_team_id"
  end

  create_table "audits", force: :cascade do |t|
    t.string "action"
    t.bigint "associated_id"
    t.string "associated_type"
    t.bigint "auditable_id"
    t.string "auditable_type"
    t.text "audited_changes"
    t.string "comment"
    t.datetime "created_at"
    t.string "remote_address"
    t.string "request_uuid"
    t.bigint "user_id"
    t.string "user_type"
    t.string "username"
    t.integer "version", default: 0
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.string "gender"
    t.integer "max_athletes"
    t.integer "max_birth_year"
    t.integer "min_birth_year"
    t.string "name", null: false
    t.integer "position"
    t.string "source_id", null: false
    t.datetime "updated_at", null: false
    t.index ["championship_id", "position"], name: "index_categories_on_championship_id_and_position"
    t.index ["championship_id"], name: "index_categories_on_championship_id"
    t.index ["source_id"], name: "index_categories_on_source_id", unique: true
  end

  create_table "championships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.json "format", default: {}, null: false
    t.string "name", null: false
    t.text "notes"
    t.date "registration_end"
    t.date "registration_start"
    t.json "rules", default: {}, null: false
    t.json "scoring", default: {}, null: false
    t.integer "season", null: false
    t.string "source_id", null: false
    t.date "start_date"
    t.string "status", default: "rascunho", null: false
    t.datetime "updated_at", null: false
    t.index ["season"], name: "index_championships_on_season"
    t.index ["source_id"], name: "index_championships_on_source_id", unique: true
    t.index ["status"], name: "index_championships_on_status"
  end

  create_table "entities", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name", null: false
    t.text "notes"
    t.string "phone"
    t.string "responsible"
    t.string "source_id", null: false
    t.datetime "updated_at", null: false
    t.string "whatsapp"
    t.index ["name"], name: "index_entities_on_name"
    t.index ["source_id"], name: "index_entities_on_source_id", unique: true
  end

  create_table "invoices", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2, default: "0.0", null: false
    t.integer "category_id"
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.date "due_date"
    t.integer "entity_id", null: false
    t.string "status", default: "pendente", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_invoices_on_category_id"
    t.index ["championship_id", "category_id"], name: "index_invoices_on_championship_id_and_category_id"
    t.index ["championship_id"], name: "index_invoices_on_championship_id"
    t.index ["entity_id", "status"], name: "index_invoices_on_entity_id_and_status"
    t.index ["entity_id"], name: "index_invoices_on_entity_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "championship_id", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "decision"
    t.string "group_key"
    t.json "highlight_videos", default: [], null: false
    t.integer "penalties_a"
    t.integer "penalties_b"
    t.string "phase", null: false
    t.integer "round_number"
    t.date "scheduled_on"
    t.string "scheduled_time"
    t.integer "score_a"
    t.integer "score_b"
    t.json "scorers", default: {}, null: false
    t.json "source_a"
    t.json "source_b"
    t.json "source_data", default: {}, null: false
    t.string "source_id", null: false
    t.string "status", default: "agendado", null: false
    t.integer "team_a_id"
    t.integer "team_b_id"
    t.datetime "updated_at", null: false
    t.string "venue"
    t.integer "winner_id"
    t.string "wo"
    t.index ["category_id", "phase", "group_key"], name: "index_matches_on_category_id_and_phase_and_group_key"
    t.index ["category_id"], name: "index_matches_on_category_id"
    t.index ["championship_id", "scheduled_on"], name: "index_matches_on_championship_id_and_scheduled_on"
    t.index ["championship_id"], name: "index_matches_on_championship_id"
    t.index ["code"], name: "index_matches_on_code"
    t.index ["source_id"], name: "index_matches_on_source_id", unique: true
    t.index ["team_a_id"], name: "index_matches_on_team_a_id"
    t.index ["team_b_id"], name: "index_matches_on_team_b_id"
    t.index ["winner_id"], name: "index_matches_on_winner_id"
  end

  create_table "standing_rows", force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.integer "draws", default: 0, null: false
    t.integer "goal_diff", default: 0, null: false
    t.integer "goals_against", default: 0, null: false
    t.integer "goals_for", default: 0, null: false
    t.integer "losses", default: 0, null: false
    t.integer "played", default: 0, null: false
    t.integer "points", default: 0, null: false
    t.integer "position", null: false
    t.boolean "qualified"
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.integer "wins", default: 0, null: false
    t.index ["category_id", "team_id"], name: "index_standing_rows_on_category_id_and_team_id", unique: true
    t.index ["category_id"], name: "index_standing_rows_on_category_id"
    t.index ["championship_id", "category_id", "position"], name: "index_standing_rows_on_competition_and_position", unique: true
    t.index ["championship_id"], name: "index_standing_rows_on_championship_id"
    t.index ["team_id"], name: "index_standing_rows_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.integer "entity_id", null: false
    t.string "finance_status", default: "pendente", null: false
    t.string "group_key"
    t.string "name", null: false
    t.string "registration_status", default: "pendente", null: false
    t.string "short_name"
    t.string "source_id", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id", "group_key"], name: "index_teams_on_category_id_and_group_key"
    t.index ["category_id"], name: "index_teams_on_category_id"
    t.index ["entity_id", "category_id"], name: "index_teams_on_entity_id_and_category_id"
    t.index ["entity_id"], name: "index_teams_on_entity_id"
    t.index ["source_id"], name: "index_teams_on_source_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "adm_master", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "athletes", "categories"
  add_foreign_key "athletes", "teams"
  add_foreign_key "categories", "championships"
  add_foreign_key "invoices", "categories"
  add_foreign_key "invoices", "championships"
  add_foreign_key "invoices", "entities"
  add_foreign_key "matches", "categories"
  add_foreign_key "matches", "championships"
  add_foreign_key "matches", "teams", column: "team_a_id"
  add_foreign_key "matches", "teams", column: "team_b_id"
  add_foreign_key "matches", "teams", column: "winner_id"
  add_foreign_key "standing_rows", "categories"
  add_foreign_key "standing_rows", "championships"
  add_foreign_key "standing_rows", "teams"
  add_foreign_key "teams", "categories"
  add_foreign_key "teams", "entities"
end
