# frozen_string_literal: true

class CreateMagenticBazaarSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :magentic_bazaar_skills do |t|
      t.references :document, null: false,
                   foreign_key: { to_table: :magentic_bazaar_documents }
      t.string  :name,            null: false
      t.string  :version,         default: "1.0.0"
      t.string  :category,        default: "Documentation Analysis"
      t.string  :uml_type
      t.string  :uml_subtype
      t.text    :tags
      t.integer :section_count,    default: 0
      t.integer :key_point_count,  default: 0
      t.boolean :has_code,         default: false
      t.boolean :has_diagrams,     default: false
      t.text    :content
      t.string  :output_path

      t.timestamps
    end
  end
end
