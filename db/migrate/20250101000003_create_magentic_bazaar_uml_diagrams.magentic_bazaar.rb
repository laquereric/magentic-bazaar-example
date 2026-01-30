# frozen_string_literal: true

class CreateMagenticBazaarUmlDiagrams < ActiveRecord::Migration[7.0]
  def change
    create_table :magentic_bazaar_uml_diagrams do |t|
      t.references :document, null: false,
                   foreign_key: { to_table: :magentic_bazaar_documents }
      t.string  :diagram_type,  null: false
      t.string  :subtype
      t.string  :title
      t.text    :puml_content
      t.string  :output_path

      t.timestamps
    end
  end
end
