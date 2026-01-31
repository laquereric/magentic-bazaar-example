class CreateFlowDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :flow_documents do |t|
      t.references :document, null: false, index: { unique: true }, foreign_key: { to_table: :magentic_bazaar_documents }
      t.references :traceable, polymorphic: true, null: true, index: false
      t.string :jsonld_type, null: false
      t.text :jsonld_payload
      t.string :status, default: "pending", null: false
      t.string :otel_trace_id
      t.datetime :matched_at

      t.timestamps
    end

    add_index :flow_documents, :jsonld_type
    add_index :flow_documents, :status
    add_index :flow_documents, :otel_trace_id
    add_index :flow_documents, [:traceable_type, :traceable_id], unique: true
  end
end
