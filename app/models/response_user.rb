class ResponseUser < ApplicationRecord
  include OtelTraceable
  otel_service_name "response.user"
  otel_layer_role :trace_terminus
  otel_flow :response, position: 9

  belongs_to :response_device, optional: true
  has_one :flow_document, as: :traceable

  validates :name, presence: true, uniqueness: true
  validates :user_type, presence: true, inclusion: { in: %w[individual group] }

  scope :active, -> { where(active: true) }
end
