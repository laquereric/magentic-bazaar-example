class RequestMiddleware < ApplicationRecord
  include OtelTraceable
  otel_service_name "request.middleware"
  otel_layer_role :span_step
  otel_flow :request, position: 3

  belongs_to :request_service, optional: true
  has_one :request_provider
  has_one :flow_document, as: :traceable

  validates :name, presence: true, uniqueness: true
  validates :middleware_type, presence: true, inclusion: { in: %w[authentication validation enrichment] }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position) }
end
