class RequestService < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :service_type, presence: true, inclusion: { in: %w[llm mcp skill] }

  scope :active, -> { where(active: true) }
end
