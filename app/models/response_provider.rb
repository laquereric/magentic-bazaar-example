class ResponseProvider < ApplicationRecord
  include OtelTraceable
  otel_service_name "response.provider"
  otel_layer_role :span_step
  otel_flow :response, position: 5

  belongs_to :request_provider, optional: true
  has_one :response_middleware
  has_one :flow_document, as: :traceable

  validates :name, presence: true, uniqueness: true
  validates :provider_type, presence: true, inclusion: { in: %w[browser workstation api] }

  scope :active, -> { where(active: true) }
end
