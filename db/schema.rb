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

ActiveRecord::Schema[8.1].define(version: 2026_09_11_140634) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "athletes", force: :cascade do |t|
    t.string "birth_certificate"
    t.date "birth_date"
    t.integer "category_id", null: false
    t.string "cell_phone"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.string "document"
    t.integer "documents_count", default: 0, null: false
    t.string "email"
    t.string "gender"
    t.string "name", null: false
    t.string "passport"
    t.string "photo_url"
    t.string "position"
    t.datetime "registration_submitted_at"
    t.string "rg"
    t.string "shirt_number"
    t.string "source_id", null: false
    t.string "status", default: "pendente", null: false
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "voter_id"
    t.index ["category_id"], name: "index_athletes_on_category_id"
    t.index ["source_id"], name: "index_athletes_on_source_id", unique: true
    t.index ["team_id", "status"], name: "index_athletes_on_team_id_and_status"
    t.index ["team_id", "user_id"], name: "index_athletes_on_team_id_and_user_id", unique: true
    t.index ["team_id"], name: "index_athletes_on_team_id"
    t.index ["user_id"], name: "index_athletes_on_user_id", unique: true
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
    t.integer "championship_id"
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

  create_table "championship_categories", force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.string "source_id", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_championship_categories_on_category_id"
    t.index ["championship_id", "category_id"], name: "index_championship_categories_on_championship_and_category", unique: true
    t.index ["championship_id"], name: "index_championship_categories_on_championship_id"
    t.index ["source_id"], name: "index_championship_categories_on_source_id", unique: true
  end

  create_table "championship_memberships", force: :cascade do |t|
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.string "role", default: "organizador", null: false
    t.string "source_id", null: false
    t.string "status", default: "ativo", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["championship_id", "user_id"], name: "index_championship_memberships_on_championship_id_and_user_id", unique: true
    t.index ["championship_id"], name: "index_championship_memberships_on_championship_id"
    t.index ["source_id"], name: "index_championship_memberships_on_source_id", unique: true
    t.index ["user_id", "status"], name: "index_championship_memberships_on_user_id_and_status"
    t.index ["user_id"], name: "index_championship_memberships_on_user_id"
  end

  create_table "championships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.json "format", default: {}, null: false
    t.string "modality", default: "football", null: false
    t.string "name", null: false
    t.text "notes"
    t.integer "public_signup_visits_count", default: 0, null: false
    t.date "registration_end"
    t.date "registration_start"
    t.json "rules", default: {}, null: false
    t.json "scoring", default: {}, null: false
    t.integer "season", null: false
    t.string "slug"
    t.string "source_id", null: false
    t.date "start_date"
    t.string "status", default: "rascunho", null: false
    t.datetime "updated_at", null: false
    t.index ["modality"], name: "index_championships_on_modality"
    t.index ["season"], name: "index_championships_on_season"
    t.index ["slug"], name: "index_championships_on_slug", unique: true
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

  create_table "match_events", force: :cascade do |t|
    t.integer "athlete_id"
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.string "kind", null: false
    t.integer "match_id"
    t.integer "minute"
    t.text "notes"
    t.string "period"
    t.json "source_data", default: {}, null: false
    t.string "source_id", null: false
    t.integer "team_id"
    t.datetime "updated_at", null: false
    t.index ["athlete_id", "kind"], name: "index_match_events_on_athlete_id_and_kind"
    t.index ["athlete_id"], name: "index_match_events_on_athlete_id"
    t.index ["championship_id"], name: "index_match_events_on_championship_id"
    t.index ["match_id", "kind"], name: "index_match_events_on_match_id_and_kind"
    t.index ["match_id"], name: "index_match_events_on_match_id"
    t.index ["source_id"], name: "index_match_events_on_source_id", unique: true
    t.index ["team_id"], name: "index_match_events_on_team_id"
  end

  create_table "match_participations", force: :cascade do |t|
    t.integer "athlete_id"
    t.string "athlete_name", null: false
    t.datetime "created_at", null: false
    t.integer "match_id", null: false
    t.text "notes"
    t.string "position"
    t.string "shirt_number"
    t.string "source_id", null: false
    t.string "status", default: "confirmado", null: false
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.index ["athlete_id"], name: "index_match_participations_on_athlete_id"
    t.index ["match_id", "status"], name: "index_match_participations_on_match_id_and_status"
    t.index ["match_id", "team_id", "athlete_id"], name: "index_match_participations_on_match_team_athlete", unique: true
    t.index ["match_id"], name: "index_match_participations_on_match_id"
    t.index ["source_id"], name: "index_match_participations_on_source_id", unique: true
    t.index ["team_id", "status"], name: "index_match_participations_on_team_id_and_status"
    t.index ["team_id"], name: "index_match_participations_on_team_id"
  end

  create_table "match_reports", force: :cascade do |t|
    t.datetime "approved_at"
    t.datetime "created_at", null: false
    t.integer "match_id", null: false
    t.text "notes"
    t.integer "referee_id"
    t.string "sheet_url"
    t.json "source_data", default: {}, null: false
    t.string "source_id", null: false
    t.string "status", default: "rascunho", null: false
    t.datetime "submitted_at"
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_match_reports_on_match_id", unique: true
    t.index ["referee_id"], name: "index_match_reports_on_referee_id"
    t.index ["source_id"], name: "index_match_reports_on_source_id", unique: true
    t.index ["status", "submitted_at"], name: "index_match_reports_on_status_and_submitted_at"
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
    t.integer "venue_id"
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
    t.index ["venue_id"], name: "index_matches_on_venue_id"
    t.index ["winner_id"], name: "index_matches_on_winner_id"
  end

  create_table "partners", force: :cascade do |t|
    t.integer "category_id"
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.boolean "highlight", default: false, null: false
    t.string "logo_url"
    t.string "name", null: false
    t.text "notes"
    t.json "source_data", default: {}, null: false
    t.string "source_id", null: false
    t.string "status", default: "ativo", null: false
    t.string "tier", default: "parceiro", null: false
    t.datetime "updated_at", null: false
    t.string "website_url"
    t.index ["category_id"], name: "index_partners_on_category_id"
    t.index ["championship_id", "status", "highlight"], name: "index_partners_on_championship_id_and_status_and_highlight"
    t.index ["championship_id", "tier"], name: "index_partners_on_championship_id_and_tier"
    t.index ["championship_id"], name: "index_partners_on_championship_id"
    t.index ["source_id"], name: "index_partners_on_source_id", unique: true
  end

  create_table "referees", force: :cascade do |t|
    t.integer "championship_id"
    t.datetime "created_at", null: false
    t.string "document"
    t.string "email"
    t.string "name", null: false
    t.text "notes"
    t.string "phone"
    t.string "source_id", null: false
    t.string "status", default: "ativo", null: false
    t.datetime "updated_at", null: false
    t.index ["championship_id", "status"], name: "index_referees_on_championship_id_and_status"
    t.index ["championship_id"], name: "index_referees_on_championship_id"
    t.index ["source_id"], name: "index_referees_on_source_id", unique: true
  end

  create_table "round_selection_athletes", force: :cascade do |t|
    t.integer "athlete_id", null: false
    t.datetime "created_at", null: false
    t.integer "position"
    t.integer "round_selection_id", null: false
    t.datetime "updated_at", null: false
    t.index ["athlete_id"], name: "index_round_selection_athletes_on_athlete_id"
    t.index ["round_selection_id", "athlete_id"], name: "idx_on_round_selection_id_athlete_id_ce14c7b16e", unique: true
    t.index ["round_selection_id"], name: "index_round_selection_athletes_on_round_selection_id"
  end

  create_table "round_selections", force: :cascade do |t|
    t.integer "category_id"
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.datetime "published_at"
    t.integer "round_number", null: false
    t.json "source_data", default: {}, null: false
    t.string "source_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_round_selections_on_category_id"
    t.index ["championship_id", "category_id", "round_number"], name: "index_round_selections_on_scope_and_round", unique: true
    t.index ["championship_id"], name: "index_round_selections_on_championship_id"
    t.index ["source_id"], name: "index_round_selections_on_source_id", unique: true
  end

  create_table "standing_rows", force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.integer "draws", default: 0, null: false
    t.integer "goal_diff", default: 0, null: false
    t.integer "goals_against", default: 0, null: false
    t.integer "goals_for", default: 0, null: false
    t.string "group_key", default: "", null: false
    t.integer "losses", default: 0, null: false
    t.integer "played", default: 0, null: false
    t.integer "points", default: 0, null: false
    t.integer "position", null: false
    t.boolean "qualified"
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.integer "wins", default: 0, null: false
    t.index ["category_id", "group_key", "team_id"], name: "index_standing_rows_on_category_group_and_team", unique: true
    t.index ["category_id"], name: "index_standing_rows_on_category_id"
    t.index ["championship_id", "category_id", "group_key", "position"], name: "index_standing_rows_on_competition_group_and_position", unique: true
    t.index ["championship_id"], name: "index_standing_rows_on_championship_id"
    t.index ["team_id"], name: "index_standing_rows_on_team_id"
  end

  create_table "suspensions", force: :cascade do |t|
    t.integer "athlete_id", null: false
    t.boolean "automatic", default: false, null: false
    t.integer "category_id"
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.date "ends_on"
    t.integer "match_event_id"
    t.integer "matches_count", default: 1, null: false
    t.text "notes"
    t.string "reason", null: false
    t.json "source_data", default: {}, null: false
    t.string "source_id", null: false
    t.date "starts_on"
    t.string "status", default: "ativa", null: false
    t.integer "team_id"
    t.datetime "updated_at", null: false
    t.index ["athlete_id", "status"], name: "index_suspensions_on_athlete_id_and_status"
    t.index ["athlete_id"], name: "index_suspensions_on_athlete_id"
    t.index ["category_id"], name: "index_suspensions_on_category_id"
    t.index ["championship_id", "category_id", "status"], name: "idx_on_championship_id_category_id_status_7b5eed8cd6"
    t.index ["championship_id"], name: "index_suspensions_on_championship_id"
    t.index ["match_event_id"], name: "index_suspensions_on_match_event_id"
    t.index ["source_id"], name: "index_suspensions_on_source_id", unique: true
    t.index ["team_id"], name: "index_suspensions_on_team_id"
  end

  create_table "team_athletes", force: :cascade do |t|
    t.integer "athlete_id", null: false
    t.datetime "created_at", null: false
    t.string "source_id", null: false
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.index ["athlete_id"], name: "index_team_athletes_on_athlete_id"
    t.index ["source_id"], name: "index_team_athletes_on_source_id", unique: true
    t.index ["team_id", "athlete_id"], name: "index_team_athletes_on_team_id_and_athlete_id", unique: true
    t.index ["team_id"], name: "index_team_athletes_on_team_id"
  end

  create_table "team_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "notes"
    t.string "role", default: "tecnico", null: false
    t.string "source_id", null: false
    t.string "status", default: "ativo", null: false
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["source_id"], name: "index_team_memberships_on_source_id", unique: true
    t.index ["team_id", "user_id"], name: "index_team_memberships_on_team_id_and_user_id", unique: true
    t.index ["team_id"], name: "index_team_memberships_on_team_id"
    t.index ["user_id", "status"], name: "index_team_memberships_on_user_id_and_status"
    t.index ["user_id"], name: "index_team_memberships_on_user_id"
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

  create_table "tranca_classificacao_rows", force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.integer "draws", default: 0, null: false
    t.integer "goal_diff", default: 0, null: false
    t.integer "goals_against", default: 0, null: false
    t.integer "goals_for", default: 0, null: false
    t.string "group_key", default: "", null: false
    t.integer "losses", default: 0, null: false
    t.integer "played", default: 0, null: false
    t.integer "points", default: 0, null: false
    t.integer "position", null: false
    t.boolean "qualified"
    t.string "source_id", null: false
    t.integer "tranca_dupla_id", null: false
    t.datetime "updated_at", null: false
    t.integer "wins", default: 0, null: false
    t.index ["category_id", "group_key", "tranca_dupla_id"], name: "index_tranca_classificacao_rows_on_group_and_dupla", unique: true
    t.index ["category_id"], name: "index_tranca_classificacao_rows_on_category_id"
    t.index ["championship_id", "category_id", "group_key", "position"], name: "index_tranca_classificacao_rows_on_scope_and_position", unique: true
    t.index ["championship_id"], name: "index_tranca_classificacao_rows_on_championship_id"
    t.index ["source_id"], name: "index_tranca_classificacao_rows_on_source_id", unique: true
    t.index ["tranca_dupla_id"], name: "index_tranca_classificacao_rows_on_tranca_dupla_id"
  end

  create_table "tranca_dupla_memberships", force: :cascade do |t|
    t.integer "athlete_id", null: false
    t.datetime "created_at", null: false
    t.integer "position"
    t.string "shirt_number"
    t.string "source_id", null: false
    t.integer "tranca_dupla_id", null: false
    t.datetime "updated_at", null: false
    t.index ["athlete_id"], name: "index_tranca_dupla_memberships_on_athlete_id"
    t.index ["source_id"], name: "index_tranca_dupla_memberships_on_source_id", unique: true
    t.index ["tranca_dupla_id", "athlete_id"], name: "index_tranca_dupla_memberships_on_dupla_and_athlete", unique: true
    t.index ["tranca_dupla_id"], name: "index_tranca_dupla_memberships_on_tranca_dupla_id"
  end

  create_table "tranca_duplas", force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.integer "entity_id"
    t.string "name", null: false
    t.string "registration_status", default: "aprovada", null: false
    t.string "short_name"
    t.string "source_id", null: false
    t.string "status", default: "ativo", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_tranca_duplas_on_category_id"
    t.index ["championship_id", "category_id", "name"], name: "index_tranca_duplas_on_scope_and_name", unique: true
    t.index ["championship_id"], name: "index_tranca_duplas_on_championship_id"
    t.index ["entity_id"], name: "index_tranca_duplas_on_entity_id"
    t.index ["source_id"], name: "index_tranca_duplas_on_source_id", unique: true
    t.index ["status"], name: "index_tranca_duplas_on_status"
  end

  create_table "tranca_mesas", force: :cascade do |t|
    t.integer "championship_id", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "location"
    t.string "name", null: false
    t.string "source_id", null: false
    t.string "status", default: "disponivel", null: false
    t.integer "tranca_rodada_id"
    t.datetime "updated_at", null: false
    t.index ["championship_id", "code"], name: "index_tranca_mesas_on_scope_and_code", unique: true
    t.index ["championship_id"], name: "index_tranca_mesas_on_championship_id"
    t.index ["source_id"], name: "index_tranca_mesas_on_source_id", unique: true
    t.index ["tranca_rodada_id"], name: "index_tranca_mesas_on_tranca_rodada_id"
  end

  create_table "tranca_partida_maos", force: :cascade do |t|
    t.boolean "batida_a", default: false, null: false
    t.boolean "batida_b", default: false, null: false
    t.boolean "canastra_limpa_a", default: false, null: false
    t.boolean "canastra_limpa_b", default: false, null: false
    t.boolean "canastra_suja_a", default: false, null: false
    t.boolean "canastra_suja_b", default: false, null: false
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.integer "desconto_a", default: 0, null: false
    t.integer "desconto_b", default: 0, null: false
    t.integer "numero", null: false
    t.text "observacoes"
    t.integer "pontos_a", default: 0, null: false
    t.integer "pontos_b", default: 0, null: false
    t.json "source_data", default: {}, null: false
    t.string "source_id", null: false
    t.integer "tranca_partida_id", null: false
    t.boolean "tres_vermelho_a", default: false, null: false
    t.boolean "tres_vermelho_b", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["championship_id", "tranca_partida_id"], name: "index_tranca_partida_maos_on_scope"
    t.index ["championship_id"], name: "index_tranca_partida_maos_on_championship_id"
    t.index ["source_id"], name: "index_tranca_partida_maos_on_source_id", unique: true
    t.index ["tranca_partida_id", "numero"], name: "index_tranca_partida_maos_on_partida_and_numero", unique: true
    t.index ["tranca_partida_id"], name: "index_tranca_partida_maos_on_tranca_partida_id"
  end

  create_table "tranca_partidas", force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "championship_id", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "decision"
    t.integer "dupla_a_id"
    t.integer "dupla_b_id"
    t.string "group_key"
    t.integer "penalties_a"
    t.integer "penalties_b"
    t.string "phase", null: false
    t.integer "round_number"
    t.date "scheduled_on"
    t.string "scheduled_time"
    t.integer "score_a"
    t.integer "score_b"
    t.json "source_data", default: {}, null: false
    t.string "source_id", null: false
    t.string "status", default: "agendado", null: false
    t.integer "tranca_mesa_id"
    t.integer "tranca_rodada_id"
    t.datetime "updated_at", null: false
    t.integer "winner_id"
    t.string "wo"
    t.index ["category_id"], name: "index_tranca_partidas_on_category_id"
    t.index ["championship_id", "phase", "round_number"], name: "index_tranca_partidas_on_scope_phase_round"
    t.index ["championship_id", "scheduled_on"], name: "index_tranca_partidas_on_championship_and_date"
    t.index ["championship_id"], name: "index_tranca_partidas_on_championship_id"
    t.index ["dupla_a_id"], name: "index_tranca_partidas_on_dupla_a_id"
    t.index ["dupla_b_id"], name: "index_tranca_partidas_on_dupla_b_id"
    t.index ["source_id"], name: "index_tranca_partidas_on_source_id", unique: true
    t.index ["tranca_mesa_id"], name: "index_tranca_partidas_on_tranca_mesa_id"
    t.index ["tranca_rodada_id"], name: "index_tranca_partidas_on_tranca_rodada_id"
    t.index ["winner_id"], name: "index_tranca_partidas_on_winner_id"
  end

  create_table "tranca_rodadas", force: :cascade do |t|
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.date "ends_on"
    t.string "label", null: false
    t.string "phase", null: false
    t.integer "round_number", null: false
    t.string "source_id", null: false
    t.date "starts_on"
    t.string "status", default: "programada", null: false
    t.datetime "updated_at", null: false
    t.index ["championship_id", "phase", "round_number"], name: "index_tranca_rodadas_on_scope_and_round", unique: true
    t.index ["championship_id"], name: "index_tranca_rodadas_on_championship_id"
    t.index ["source_id"], name: "index_tranca_rodadas_on_source_id", unique: true
  end

  create_table "tranca_settings", force: :cascade do |t|
    t.integer "championship_id", null: false
    t.datetime "created_at", null: false
    t.json "format", default: {}, null: false
    t.json "rules", default: {}, null: false
    t.json "scoring", default: {}, null: false
    t.string "source_id", null: false
    t.datetime "updated_at", null: false
    t.index ["championship_id"], name: "index_tranca_settings_on_championship_id", unique: true
    t.index ["source_id"], name: "index_tranca_settings_on_source_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "preferred_theme", default: "corporate", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "adm_master", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["preferred_theme"], name: "index_users_on_preferred_theme"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "venues", force: :cascade do |t|
    t.string "address"
    t.integer "championship_id"
    t.string "city"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.text "notes"
    t.string "short_name"
    t.string "source_id", null: false
    t.string "status", default: "ativo", null: false
    t.datetime "updated_at", null: false
    t.index ["championship_id", "status"], name: "index_venues_on_championship_id_and_status"
    t.index ["championship_id"], name: "index_venues_on_championship_id"
    t.index ["source_id"], name: "index_venues_on_source_id", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "athletes", "categories"
  add_foreign_key "athletes", "teams"
  add_foreign_key "athletes", "users"
  add_foreign_key "categories", "championships", on_delete: :nullify
  add_foreign_key "championship_categories", "categories"
  add_foreign_key "championship_categories", "championships"
  add_foreign_key "championship_memberships", "championships"
  add_foreign_key "championship_memberships", "users"
  add_foreign_key "invoices", "categories"
  add_foreign_key "invoices", "championships"
  add_foreign_key "invoices", "entities"
  add_foreign_key "match_events", "athletes", on_delete: :nullify
  add_foreign_key "match_events", "championships"
  add_foreign_key "match_events", "matches"
  add_foreign_key "match_events", "teams", on_delete: :nullify
  add_foreign_key "match_participations", "athletes", on_delete: :nullify
  add_foreign_key "match_participations", "matches", on_delete: :cascade
  add_foreign_key "match_participations", "teams", on_delete: :cascade
  add_foreign_key "match_reports", "matches"
  add_foreign_key "match_reports", "referees"
  add_foreign_key "matches", "categories"
  add_foreign_key "matches", "championships"
  add_foreign_key "matches", "teams", column: "team_a_id"
  add_foreign_key "matches", "teams", column: "team_b_id"
  add_foreign_key "matches", "teams", column: "winner_id"
  add_foreign_key "matches", "venues"
  add_foreign_key "partners", "categories"
  add_foreign_key "partners", "championships"
  add_foreign_key "referees", "championships"
  add_foreign_key "round_selection_athletes", "athletes"
  add_foreign_key "round_selection_athletes", "round_selections"
  add_foreign_key "round_selections", "categories"
  add_foreign_key "round_selections", "championships"
  add_foreign_key "standing_rows", "categories"
  add_foreign_key "standing_rows", "championships"
  add_foreign_key "standing_rows", "teams"
  add_foreign_key "suspensions", "athletes"
  add_foreign_key "suspensions", "categories"
  add_foreign_key "suspensions", "championships"
  add_foreign_key "suspensions", "match_events"
  add_foreign_key "suspensions", "teams"
  add_foreign_key "team_athletes", "athletes", on_delete: :cascade
  add_foreign_key "team_athletes", "teams", on_delete: :cascade
  add_foreign_key "team_memberships", "teams"
  add_foreign_key "team_memberships", "users"
  add_foreign_key "teams", "categories"
  add_foreign_key "teams", "entities"
  add_foreign_key "tranca_classificacao_rows", "categories"
  add_foreign_key "tranca_classificacao_rows", "championships"
  add_foreign_key "tranca_classificacao_rows", "tranca_duplas"
  add_foreign_key "tranca_dupla_memberships", "athletes"
  add_foreign_key "tranca_dupla_memberships", "tranca_duplas"
  add_foreign_key "tranca_duplas", "categories"
  add_foreign_key "tranca_duplas", "championships"
  add_foreign_key "tranca_duplas", "entities"
  add_foreign_key "tranca_mesas", "championships"
  add_foreign_key "tranca_mesas", "tranca_rodadas"
  add_foreign_key "tranca_partida_maos", "championships"
  add_foreign_key "tranca_partida_maos", "tranca_partidas"
  add_foreign_key "tranca_partidas", "categories"
  add_foreign_key "tranca_partidas", "championships"
  add_foreign_key "tranca_partidas", "tranca_duplas", column: "dupla_a_id"
  add_foreign_key "tranca_partidas", "tranca_duplas", column: "dupla_b_id"
  add_foreign_key "tranca_partidas", "tranca_duplas", column: "winner_id"
  add_foreign_key "tranca_partidas", "tranca_mesas"
  add_foreign_key "tranca_partidas", "tranca_rodadas"
  add_foreign_key "tranca_rodadas", "championships"
  add_foreign_key "tranca_settings", "championships"
  add_foreign_key "venues", "championships"
end
