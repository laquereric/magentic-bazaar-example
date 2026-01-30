# This migration comes from llm_engine (originally 20260130000001)
class CreateLlmEngineTables < ActiveRecord::Migration[7.0]
  def change
    create_table :llm_engine_llm_vendors do |t|
      t.string :name, null: false
      t.string :website_url
      t.text :description
      t.timestamps
    end
    add_index :llm_engine_llm_vendors, :name, unique: true

    create_table :llm_engine_llm_provider_gems do |t|
      t.string :gem_name, null: false
      t.string :require_name
      t.string :module_name
      t.boolean :official, default: false
      t.references :llm_vendor, null: true, foreign_key: { to_table: :llm_engine_llm_vendors }
      t.timestamps
    end
    add_index :llm_engine_llm_provider_gems, :gem_name, unique: true

    create_table :llm_engine_llm_providers do |t|
      t.string :name, null: false
      t.boolean :active, default: true
      t.references :llm_provider_gem, null: false, foreign_key: { to_table: :llm_engine_llm_provider_gems }
      t.timestamps
    end
    add_index :llm_engine_llm_providers, :name, unique: true

    create_table :llm_engine_llm_models do |t|
      t.string :api_name, null: false
      t.string :display_name
      t.string :model_type
      t.integer :context_window
      t.boolean :supports_streaming, default: false
      t.boolean :supports_vision, default: false
      t.boolean :supports_tools, default: false
      t.boolean :active, default: true
      t.references :llm_vendor, null: false, foreign_key: { to_table: :llm_engine_llm_vendors }
      t.timestamps
    end
    add_index :llm_engine_llm_models, [:llm_vendor_id, :api_name], unique: true

    create_table :llm_engine_llm_model_configurations do |t|
      t.references :llm_provider, null: false, foreign_key: { to_table: :llm_engine_llm_providers }
      t.references :llm_model, null: false, foreign_key: { to_table: :llm_engine_llm_models }
      t.text :encrypted_credentials
      t.json :settings, default: {}
      t.boolean :active, default: true
      t.timestamps
    end
    add_index :llm_engine_llm_model_configurations,
              [:llm_provider_id, :llm_model_id],
              unique: true,
              name: "idx_llm_engine_configs_on_provider_and_model"
  end
end
