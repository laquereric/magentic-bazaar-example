# frozen_string_literal: true

class CreateMagenticBazaarIngestions < ActiveRecord::Migration[7.0]
  def change
    create_table :magentic_bazaar_ingestions do |t|
      t.string  :git_sha
      t.string  :direction,           null: false
      t.string  :status,              default: "pending"
      t.integer :documents_count,     default: 0
      t.integer :documents_processed, default: 0
      t.text    :error_log

      t.timestamps
    end
  end
end
