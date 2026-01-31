class RequestService < ApplicationRecord
  include OtelTraceable
  otel_service_name "request.service"
  otel_layer_role :span_step
  otel_flow :request, position: 2

  belongs_to :request_device, optional: true
  has_one :request_middleware
  has_one :flow_document, as: :traceable

  validates :name, presence: true, uniqueness: true
  validates :service_type, presence: true, inclusion: { in: %w[llm mcp skill] }

  scope :active, -> { where(active: true) }
end
