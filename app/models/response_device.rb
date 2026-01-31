class ResponseDevice < ApplicationRecord
  include OtelTraceable
  otel_service_name "response.device"
  otel_layer_role :span_step
  otel_flow :response, position: 8

  belongs_to :response_service, optional: true
  has_one :response_user
  has_one :flow_document, as: :traceable

  validates :name, presence: true, uniqueness: true
  validates :device_type, presence: true, inclusion: { in: %w[phone laptop server] }

  scope :active, -> { where(active: true) }
end
