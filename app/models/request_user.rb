class RequestUser < ApplicationRecord
  include OtelTraceable
  otel_service_name "request.user"
  otel_layer_role :trace_origin
  otel_flow :request, position: 0

  has_one :request_device
  has_one :flow_document, as: :traceable

  validates :name, presence: true, uniqueness: true
  validates :user_type, presence: true, inclusion: { in: %w[individual group] }

  scope :active, -> { where(active: true) }
end
