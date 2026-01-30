class CreateContainerRuntimes < ActiveRecord::Migration[8.1]
  def change
    create_table :container_runtimes do |t|
      t.string :name, null: false
      t.string :driver
      t.string :socket_path
      t.text :connection_options
      t.boolean :active, default: true
      t.string :status, default: "inactive"
      t.datetime :last_tested_at
      t.text :error_log
      t.timestamps
    end

    add_index :container_runtimes, :name
    add_index :container_runtimes, :driver
    add_index :container_runtimes, :status
  end
end
