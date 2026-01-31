class FlowDocumentMatcher
  TYPE_FIELD_MAP = {
    "RequestUser"        => :user_type,
    "RequestDevice"      => :device_type,
    "RequestService"     => :service_type,
    "RequestMiddleware"  => :middleware_type,
    "RequestProvider"    => :provider_type,
    "ResponseProvider"   => :provider_type,
    "ResponseMiddleware" => :middleware_type,
    "ResponseService"    => :service_type,
    "ResponseDevice"     => :device_type,
    "ResponseUser"       => :user_type
  }.freeze

  def self.type_field_for(model_class)
    TYPE_FIELD_MAP[model_class.name]
  end

  # Ingest a JSON-LD payload string tied to a MagenticBazaar::Document
  def self.ingest(document, jsonld_string)
    payload = JSON.parse(jsonld_string)
    jsonld_type = payload["@type"]

    flow_doc = FlowDocument.create!(
      document: document,
      jsonld_type: jsonld_type,
      jsonld_payload: jsonld_string,
      status: "pending"
    )

    flow_doc.match!
    flow_doc
  end

  # Batch-match all pending FlowDocuments
  def self.match_pending!
    FlowDocument.pending.find_each(&:match!)
  end
end
