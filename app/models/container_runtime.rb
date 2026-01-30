class ContainerRuntime < ApplicationRecord
  validates :name, presence: true

  serialize :connection_options, coder: JSON

  scope :active, -> { where(active: true) }

  def test_connection!
    Container.configure do |c|
      c.driver = driver.to_sym
      c.socket_path = socket_path if socket_path.present?
      c.connection_options = connection_options || {}
    end
    containers = Container.client.list
    update!(last_tested_at: Time.current, status: "active", error_log: nil)
    containers
  rescue => e
    update!(status: "error", error_log: e.message)
    raise
  end
end
