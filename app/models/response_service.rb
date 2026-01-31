class ResponseService < ApplicationRecord
  include OtelTraceable
  otel_service_name "response.service"
  otel_layer_role :span_step
  otel_flow :response, position: 7

  belongs_to :response_middleware, optional: true
  has_one :response_device
  has_one :flow_document, as: :traceable

  validates :name, presence: true, uniqueness: true
  validates :service_type, presence: true, inclusion: { in: %w[llm mcp skill] }

  scope :active, -> { where(active: true) }
end
