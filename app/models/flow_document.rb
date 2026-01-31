class FlowDocument < ApplicationRecord
  belongs_to :document, class_name: "MagenticBazaar::Document"
  belongs_to :traceable, polymorphic: true, optional: true

  validates :jsonld_type, presence: true
  validates :document_id, uniqueness: true

  scope :pending,  -> { where(status: "pending") }
  scope :matched,  -> { where(status: "matched") }
  scope :errored,  -> { where(status: "error") }
  scope :recent,   -> { order(created_at: :desc) }

  JSONLD_TYPE_MAP = {
    "schema:RequestUser"       => "RequestUser",
    "schema:RequestDevice"     => "RequestDevice",
    "schema:RequestService"    => "RequestService",
    "schema:RequestMiddleware" => "RequestMiddleware",
    "schema:RequestProvider"   => "RequestProvider",
    "schema:ResponseProvider"  => "ResponseProvider",
    "schema:ResponseMiddleware"=> "ResponseMiddleware",
    "schema:ResponseService"   => "ResponseService",
    "schema:ResponseDevice"    => "ResponseDevice",
    "schema:ResponseUser"      => "ResponseUser"
  }.freeze

  def match!
    model_class_name = JSONLD_TYPE_MAP[jsonld_type]
    unless model_class_name
      update!(status: "error")
      return
    end

    model_class = model_class_name.constantize
    payload = jsonld_payload.present? ? JSON.parse(jsonld_payload) : {}
    name = payload["name"] || document.title

    record = model_class.find_or_initialize_by(name: name)
    type_field = FlowDocumentMatcher.type_field_for(model_class)
    if type_field && payload[type_field.to_s]
      record.public_send(:"#{type_field}=", payload[type_field.to_s])
    end
    record.save!

    update!(traceable: record, status: "matched", matched_at: Time.current)
  end
end
