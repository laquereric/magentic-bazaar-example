class RequestProvider < ApplicationRecord
  include OtelTraceable
  otel_service_name "request.provider"
  otel_layer_role :span_terminus
  otel_flow :request, position: 4

  belongs_to :request_middleware, optional: true
  has_one :response_provider
  has_one :flow_document, as: :traceable

  validates :name, presence: true, uniqueness: true
  validates :provider_type, presence: true, inclusion: { in: %w[browser workstation api] }

  scope :active, -> { where(active: true) }
end
