class CreateHostingProviders < ActiveRecord::Migration[8.1]
  def change
    create_table :hosting_providers do |t|
      t.string :name, null: false
      t.string :provider_type
      t.text :api_token
      t.string :base_url
      t.integer :timeout, default: 30
      t.integer :per_page, default: 50
      t.boolean :active, default: true
      t.string :status, default: "inactive"
      t.datetime :last_tested_at
      t.text :error_log
      t.timestamps
    end

    add_index :hosting_providers, :name
    add_index :hosting_providers, :provider_type
    add_index :hosting_providers, :status
  end
end
