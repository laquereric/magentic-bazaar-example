# frozen_string_literal: true

class CreateMagenticBazaarSkillProviders < ActiveRecord::Migration[8.1]
  def change
    create_table :magentic_bazaar_skill_providers do |t|
      t.string  :name,            null: false
      t.text    :description
      t.boolean :active,          default: true
      t.string  :transport_type
      t.string  :command
      t.string  :url
      t.text    :args
      t.text    :env_vars
      t.text    :tools
      t.string  :version,         default: "1.0.0"
      t.string  :category
      t.references :document, null: true,
                   foreign_key: { to_table: :magentic_bazaar_documents }
      t.references :mcp_provider, null: true,
                   foreign_key: { to_table: :magentic_bazaar_mcp_providers }
      t.string  :status,          default: "disconnected"
      t.datetime :last_connected_at
      t.text    :error_log

      t.timestamps
    end

    add_index :magentic_bazaar_skill_providers, :name
    add_index :magentic_bazaar_skill_providers, :status
    add_index :magentic_bazaar_skill_providers, :transport_type
  end
end
