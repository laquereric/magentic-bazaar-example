class CreateRequestFlowTables < ActiveRecord::Migration[8.1]
  def change
    create_table :request_users do |t|
      t.string :name, null: false
      t.string :user_type, null: false
      t.boolean :active, default: true
      t.string :status, default: "active"

      t.timestamps
    end

    add_index :request_users, :name, unique: true

    create_table :request_devices do |t|
      t.string :name, null: false
      t.string :device_type, null: false
      t.boolean :active, default: true
      t.string :status, default: "active"

      t.timestamps
    end

    add_index :request_devices, :name, unique: true

    create_table :request_services do |t|
      t.string :name, null: false
      t.string :service_type, null: false
      t.boolean :active, default: true
      t.string :status, default: "active"

      t.timestamps
    end

    add_index :request_services, :name, unique: true

    create_table :request_middlewares do |t|
      t.string :name, null: false
      t.string :middleware_type, null: false
      t.integer :position
      t.boolean :active, default: true
      t.string :status, default: "active"

      t.timestamps
    end

    add_index :request_middlewares, :name, unique: true

    create_table :request_providers do |t|
      t.string :name, null: false
      t.string :provider_type, null: false
      t.boolean :active, default: true
      t.string :status, default: "active"

      t.timestamps
    end

    add_index :request_providers, :name, unique: true
  end
end
