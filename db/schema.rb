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

ActiveRecord::Schema[8.1].define(version: 2026_01_30_210001) do
  create_table "container_runtimes", force: :cascade do |t|
    t.boolean "active", default: true
    t.text "connection_options"
    t.datetime "created_at", null: false
    t.string "driver"
    t.text "error_log"
    t.datetime "last_tested_at"
    t.string "name", null: false
    t.string "socket_path"
    t.string "status", default: "inactive"
    t.datetime "updated_at", null: false
    t.index ["driver"], name: "index_container_runtimes_on_driver"
    t.index ["name"], name: "index_container_runtimes_on_name"
    t.index ["status"], name: "index_container_runtimes_on_status"
  end

  create_table "hosting_providers", force: :cascade do |t|
    t.boolean "active", default: true
    t.text "api_token"
    t.string "base_url"
    t.datetime "created_at", null: false
    t.text "error_log"
    t.datetime "last_tested_at"
    t.string "name", null: false
    t.integer "per_page", default: 50
    t.string "provider_type"
    t.string "status", default: "inactive"
    t.integer "timeout", default: 30
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_hosting_providers_on_name"
    t.index ["provider_type"], name: "index_hosting_providers_on_provider_type"
    t.index ["status"], name: "index_hosting_providers_on_status"
  end

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
    t.datetime "last_tested_at"
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

  create_table "magentic_bazaar_mcp_providers", force: :cascade do |t|
    t.boolean "active", default: true
    t.text "args"
    t.string "category"
    t.string "command"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "document_id"
    t.text "env_vars"
    t.text "error_log"
    t.datetime "last_connected_at"
    t.string "name", null: false
    t.string "status", default: "disconnected"
    t.text "tools"
    t.string "transport_type"
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "version", default: "1.0.0"
    t.index ["document_id"], name: "index_magentic_bazaar_mcp_providers_on_document_id"
    t.index ["name"], name: "index_magentic_bazaar_mcp_providers_on_name"
    t.index ["status"], name: "index_magentic_bazaar_mcp_providers_on_status"
    t.index ["transport_type"], name: "index_magentic_bazaar_mcp_providers_on_transport_type"
  end

  create_table "magentic_bazaar_mcp_servers", force: :cascade do |t|
    t.boolean "active", default: true
    t.text "args"
    t.string "category"
    t.string "command"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "document_id"
    t.text "env_vars"
    t.text "error_log"
    t.datetime "last_connected_at"
    t.string "name", null: false
    t.string "status", default: "inactive"
    t.text "tools"
    t.string "transport_type"
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "version", default: "1.0.0"
    t.index ["document_id"], name: "index_magentic_bazaar_mcp_servers_on_document_id"
    t.index ["name"], name: "index_magentic_bazaar_mcp_servers_on_name"
    t.index ["status"], name: "index_magentic_bazaar_mcp_servers_on_status"
    t.index ["transport_type"], name: "index_magentic_bazaar_mcp_servers_on_transport_type"
  end

  create_table "magentic_bazaar_skill_providers", force: :cascade do |t|
    t.boolean "active", default: true
    t.text "args"
    t.string "category"
    t.string "command"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "document_id"
    t.text "env_vars"
    t.text "error_log"
    t.datetime "last_connected_at"
    t.integer "mcp_provider_id"
    t.string "name", null: false
    t.string "status", default: "disconnected"
    t.text "tools"
    t.string "transport_type"
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "version", default: "1.0.0"
    t.index ["document_id"], name: "index_magentic_bazaar_skill_providers_on_document_id"
    t.index ["mcp_provider_id"], name: "index_magentic_bazaar_skill_providers_on_mcp_provider_id"
    t.index ["name"], name: "index_magentic_bazaar_skill_providers_on_name"
    t.index ["status"], name: "index_magentic_bazaar_skill_providers_on_status"
    t.index ["transport_type"], name: "index_magentic_bazaar_skill_providers_on_transport_type"
  end

  create_table "magentic_bazaar_skill_servers", force: :cascade do |t|
    t.boolean "active", default: true
    t.text "args"
    t.string "category"
    t.string "command"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "document_id"
    t.text "env_vars"
    t.text "error_log"
    t.datetime "last_connected_at"
    t.integer "mcp_server_id"
    t.string "name", null: false
    t.string "status", default: "inactive"
    t.text "tools"
    t.string "transport_type"
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "version", default: "1.0.0"
    t.index ["document_id"], name: "index_magentic_bazaar_skill_servers_on_document_id"
    t.index ["mcp_server_id"], name: "index_magentic_bazaar_skill_servers_on_mcp_server_id"
    t.index ["name"], name: "index_magentic_bazaar_skill_servers_on_name"
    t.index ["status"], name: "index_magentic_bazaar_skill_servers_on_status"
    t.index ["transport_type"], name: "index_magentic_bazaar_skill_servers_on_transport_type"
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

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
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
  add_foreign_key "magentic_bazaar_mcp_providers", "magentic_bazaar_documents", column: "document_id"
  add_foreign_key "magentic_bazaar_mcp_servers", "magentic_bazaar_documents", column: "document_id"
  add_foreign_key "magentic_bazaar_skill_providers", "magentic_bazaar_documents", column: "document_id"
  add_foreign_key "magentic_bazaar_skill_providers", "magentic_bazaar_mcp_providers", column: "mcp_provider_id"
  add_foreign_key "magentic_bazaar_skill_servers", "magentic_bazaar_documents", column: "document_id"
  add_foreign_key "magentic_bazaar_skill_servers", "magentic_bazaar_mcp_servers", column: "mcp_server_id"
  add_foreign_key "magentic_bazaar_skills", "magentic_bazaar_documents", column: "document_id"
  add_foreign_key "magentic_bazaar_uml_diagrams", "magentic_bazaar_documents", column: "document_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
end
