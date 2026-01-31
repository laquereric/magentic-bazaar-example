class CreateResponseFlowTables < ActiveRecord::Migration[8.1]
  def change
    create_table :response_providers do |t|
      t.string :name, null: false
      t.string :provider_type, null: false
      t.boolean :active, default: true
      t.string :status, default: "active"

      t.timestamps
    end

    add_index :response_providers, :name, unique: true

    create_table :response_middlewares do |t|
      t.string :name, null: false
      t.string :middleware_type, null: false
      t.integer :position
      t.boolean :active, default: true
      t.string :status, default: "active"

      t.timestamps
    end

    add_index :response_middlewares, :name, unique: true

    create_table :response_services do |t|
      t.string :name, null: false
      t.string :service_type, null: false
      t.boolean :active, default: true
      t.string :status, default: "active"

      t.timestamps
    end

    add_index :response_services, :name, unique: true

    create_table :response_devices do |t|
      t.string :name, null: false
      t.string :device_type, null: false
      t.boolean :active, default: true
      t.string :status, default: "active"

      t.timestamps
    end

    add_index :response_devices, :name, unique: true

    create_table :response_users do |t|
      t.string :name, null: false
      t.string :user_type, null: false
      t.boolean :active, default: true
      t.string :status, default: "active"

      t.timestamps
    end

    add_index :response_users, :name, unique: true
  end
end
