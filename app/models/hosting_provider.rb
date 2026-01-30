class HostingProvider < ApplicationRecord
  encrypts :api_token

  validates :name, presence: true

  scope :active, -> { where(active: true) }

  def test_connection!
    client = Hosting.client(provider_type.to_sym, api_token: api_token, base_url: base_url, timeout: timeout, per_page: per_page)
    client.billing.catalog
    update!(last_tested_at: Time.current, status: "active", error_log: nil)
  rescue => e
    update!(status: "error", error_log: e.message)
    raise
  end
end
