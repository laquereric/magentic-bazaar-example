class RequestDevice < ApplicationRecord
  include OtelTraceable
  otel_service_name "request.device"
  otel_layer_role :span_step
  otel_flow :request, position: 1

  belongs_to :request_user, optional: true
  has_one :request_service
  has_one :flow_document, as: :traceable

  validates :name, presence: true, uniqueness: true
  validates :device_type, presence: true, inclusion: { in: %w[phone laptop server] }

  scope :active, -> { where(active: true) }
end
