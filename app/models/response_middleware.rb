class ResponseMiddleware < ApplicationRecord
  include OtelTraceable
  otel_service_name "response.middleware"
  otel_layer_role :span_step
  otel_flow :response, position: 6

  belongs_to :response_provider, optional: true
  has_one :response_service
  has_one :flow_document, as: :traceable

  validates :name, presence: true, uniqueness: true
  validates :middleware_type, presence: true, inclusion: { in: %w[authentication validation enrichment] }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position) }
end
