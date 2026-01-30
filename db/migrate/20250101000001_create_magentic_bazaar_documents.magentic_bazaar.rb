# frozen_string_literal: true

class CreateMagenticBazaarDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :magentic_bazaar_documents do |t|
      t.string  :title,             null: false
      t.string  :original_filename, null: false
      t.string  :uuid7,             null: false, limit: 7
      t.string  :git_sha
      t.string  :file_type
      t.string  :content_hash
      t.integer :word_count,        default: 0
      t.text    :raw_content
      t.string  :source_path
      t.string  :archived_path
      t.string  :status,            default: "pending"
      t.references :ingestion, foreign_key: { to_table: :magentic_bazaar_ingestions }, null: true

      t.timestamps
    end

    add_index :magentic_bazaar_documents, :uuid7, unique: true
    add_index :magentic_bazaar_documents, :status
    add_index :magentic_bazaar_documents, :content_hash
  end
end
