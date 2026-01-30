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

ActiveRecord::Schema[8.1].define(version: 2026_01_30_135324) do
  create_table "magentic_bazaar_documents", force: :cascade do |t|
    t.string "archived_path"
    t.string "content_hash"
    t.datetime "created_at", null: false
    t.string "file_type"
    t.string "git_sha"
    t.integer "ingestion_id"
    t.string "original_filename", null: false
    t.text "raw_content"
    t.string "source_path"
    t.string "status", default: "pending"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "uuid7", limit: 7, null: false
    t.integer "word_count", default: 0
    t.index ["content_hash"], name: "index_magentic_bazaar_documents_on_content_hash"
    t.index ["ingestion_id"], name: "index_magentic_bazaar_documents_on_ingestion_id"
    t.index ["status"], name: "index_magentic_bazaar_documents_on_status"
    t.index ["uuid7"], name: "index_magentic_bazaar_documents_on_uuid7", unique: true
  end

  create_table "magentic_bazaar_ingestions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "direction", null: false
    t.integer "documents_count", default: 0
    t.integer "documents_processed", default: 0
    t.text "error_log"
    t.string "git_sha"
    t.string "status", default: "pending"
    t.datetime "updated_at", null: false
  end

  create_table "magentic_bazaar_skills", force: :cascade do |t|
    t.string "category", default: "Documentation Analysis"
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "document_id", null: false
    t.boolean "has_code", default: false
    t.boolean "has_diagrams", default: false
    t.integer "key_point_count", default: 0
    t.string "name", null: false
    t.string "output_path"
    t.integer "section_count", default: 0
    t.text "tags"
    t.string "uml_subtype"
    t.string "uml_type"
    t.datetime "updated_at", null: false
    t.string "version", default: "1.0.0"
    t.index ["document_id"], name: "index_magentic_bazaar_skills_on_document_id"
  end

  create_table "magentic_bazaar_uml_diagrams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "diagram_type", null: false
    t.integer "document_id", null: false
    t.string "output_path"
    t.text "puml_content"
    t.string "subtype"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_magentic_bazaar_uml_diagrams_on_document_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "magentic_bazaar_documents", "magentic_bazaar_ingestions", column: "ingestion_id"
  add_foreign_key "magentic_bazaar_skills", "magentic_bazaar_documents", column: "document_id"
  add_foreign_key "magentic_bazaar_uml_diagrams", "magentic_bazaar_documents", column: "document_id"
  add_foreign_key "sessions", "users"
end
