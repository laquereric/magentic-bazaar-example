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

ActiveRecord::Schema[8.1].define(version: 2026_01_30_161947) do
  create_table "llm_engine_llm_model_configurations", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.text "encrypted_credentials"
    t.integer "llm_model_id", null: false
    t.integer "llm_provider_id", null: false
    t.json "settings", default: {}
    t.datetime "updated_at", null: false
    t.index ["llm_model_id"], name: "index_llm_engine_llm_model_configurations_on_llm_model_id"
    t.index ["llm_provider_id", "llm_model_id"], name: "idx_llm_engine_configs_on_provider_and_model", unique: true
    t.index ["llm_provider_id"], name: "index_llm_engine_llm_model_configurations_on_llm_provider_id"
  end

  create_table "llm_engine_llm_models", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "api_name", null: false
    t.integer "context_window"
    t.datetime "created_at", null: false
    t.string "display_name"
    t.integer "llm_vendor_id", null: false
    t.string "model_type"
    t.boolean "supports_streaming", default: false
    t.boolean "supports_tools", default: false
    t.boolean "supports_vision", default: false
    t.datetime "updated_at", null: false
    t.index ["llm_vendor_id", "api_name"], name: "index_llm_engine_llm_models_on_llm_vendor_id_and_api_name", unique: true
    t.index ["llm_vendor_id"], name: "index_llm_engine_llm_models_on_llm_vendor_id"
  end

  create_table "llm_engine_llm_provider_gems", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "gem_name", null: false
    t.integer "llm_vendor_id"
    t.string "module_name"
    t.boolean "official", default: false
    t.string "require_name"
    t.datetime "updated_at", null: false
    t.index ["gem_name"], name: "index_llm_engine_llm_provider_gems_on_gem_name", unique: true
    t.index ["llm_vendor_id"], name: "index_llm_engine_llm_provider_gems_on_llm_vendor_id"
  end

  create_table "llm_engine_llm_providers", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.integer "llm_provider_gem_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["llm_provider_gem_id"], name: "index_llm_engine_llm_providers_on_llm_provider_gem_id"
    t.index ["name"], name: "index_llm_engine_llm_providers_on_name", unique: true
  end

  create_table "llm_engine_llm_vendors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "website_url"
    t.index ["name"], name: "index_llm_engine_llm_vendors_on_name", unique: true
  end

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

  add_foreign_key "llm_engine_llm_model_configurations", "llm_engine_llm_models", column: "llm_model_id"
  add_foreign_key "llm_engine_llm_model_configurations", "llm_engine_llm_providers", column: "llm_provider_id"
  add_foreign_key "llm_engine_llm_models", "llm_engine_llm_vendors", column: "llm_vendor_id"
  add_foreign_key "llm_engine_llm_provider_gems", "llm_engine_llm_vendors", column: "llm_vendor_id"
  add_foreign_key "llm_engine_llm_providers", "llm_engine_llm_provider_gems", column: "llm_provider_gem_id"
  add_foreign_key "magentic_bazaar_documents", "magentic_bazaar_ingestions", column: "ingestion_id"
  add_foreign_key "magentic_bazaar_skills", "magentic_bazaar_documents", column: "document_id"
  add_foreign_key "magentic_bazaar_uml_diagrams", "magentic_bazaar_documents", column: "document_id"
  add_foreign_key "sessions", "users"
end
