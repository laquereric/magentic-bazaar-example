class DashboardController < ApplicationController
  layout "inertia", only: [:show]

  def show
    tracer = OpenTelemetry.tracer_provider.tracer("dashboard")

    tracer.in_span("dashboard.build_flow") do |root_span|
      # Request flow (forward)
      req_users       = trace_query("request.user")       { RequestUser.all }
      req_devices     = trace_query("request.device")     { RequestDevice.all }
      req_services    = trace_query("request.service")    { RequestService.all }
      req_middlewares = trace_query("request.middleware")  { RequestMiddleware.all.order(:position) }
      req_providers   = trace_query("request.provider")   { RequestProvider.all }

      # Response flow (reverse)
      res_providers   = trace_query("response.provider")   { ResponseProvider.all }
      res_middlewares = trace_query("response.middleware")  { ResponseMiddleware.all.order(:position) }
      res_services    = trace_query("response.service")    { ResponseService.all }
      res_devices     = trace_query("response.device")     { ResponseDevice.all }
      res_users       = trace_query("response.user")       { ResponseUser.all }

      puml_request = build_puml_request(req_users, req_devices, req_services, req_middlewares, req_providers)
      puml_response = build_puml_response(res_providers, res_middlewares, res_services, res_devices, res_users)

      recent_ingestions = MagenticBazaar::Ingestion.order(created_at: :desc).limit(5).map do |ing|
        {
          id: ing.id,
          direction: ing.direction,
          status: ing.status,
          documents_count: ing.documents_count,
          documents_processed: ing.documents_processed,
          created_at: ing.created_at.iso8601
        }
      end

      flow_documents = FlowDocument.recent.limit(20).includes(:document).map do |fd|
        {
          id: fd.id,
          document_title: fd.document.title,
          jsonld_type: fd.jsonld_type,
          status: fd.status,
          traceable_type: fd.traceable_type,
          traceable_id: fd.traceable_id,
          matched_at: fd.matched_at&.iso8601,
          created_at: fd.created_at.iso8601
        }
      end

      otel_context = {
        trace_id: root_span.context.hex_trace_id,
        span_id:  root_span.context.hex_span_id,
        flow_layers: [
          req_users, req_devices, req_services, req_middlewares, req_providers,
          res_providers, res_middlewares, res_services, res_devices, res_users
        ].map { |records| records.first&.otel_metadata }.compact
      }

      render inertia: "Dashboard/Show", props: {
        puml_request: puml_request,
        puml_response: puml_response,
        flow_documents: flow_documents,
        request_layers: {
          users:       layer_summary(req_users, :user_type),
          devices:     layer_summary(req_devices, :device_type),
          services:    layer_summary(req_services, :service_type),
          middlewares: layer_summary(req_middlewares, :middleware_type),
          providers:   layer_summary(req_providers, :provider_type)
        },
        response_layers: {
          providers:   layer_summary(res_providers, :provider_type),
          middlewares: layer_summary(res_middlewares, :middleware_type),
          services:    layer_summary(res_services, :service_type),
          devices:     layer_summary(res_devices, :device_type),
          users:       layer_summary(res_users, :user_type)
        },
        recent_ingestions: recent_ingestions,
        otel_context: otel_context
      }
    end
  end

  private

  def trace_query(service_name, &block)
    tracer = OpenTelemetry.tracer_provider.tracer("dashboard")
    tracer.in_span("query.#{service_name}", attributes: { "otel.service_name" => service_name }) do
      block.call
    end
  end

  def layer_summary(records, type_field)
    model_class = records.first&.class
    otel = if model_class&.respond_to?(:otel_config)
             { service_name: model_class.otel_config[:service_name], layer_role: model_class.otel_config[:layer_role] }
           else
             {}
           end

    {
      total: records.size,
      active: records.count(&:active),
      by_type: records.group_by(&type_field).transform_values(&:count),
      otel: otel
    }
  end

  def build_puml_request(req_users, req_devices, req_services, req_middlewares, req_providers)
    act = ->(col) { col.select(&:active).map(&:name) }

    build_sequence_diagram do |d|
      d.participant "User",       as: "U"
      d.participant "Device",     as: "D"
      d.participant "Service",    as: "S"
      d.participant "Middleware",  as: "M"
      d.participant "Provider",   as: "P"

      d.blank_line
      d.message "U", "D", "Select device"
      d.message "D", "S", "Route to service"
      d.message "S", "M", "Apply middleware"
      d.message "M", "P", "Fulfill request"

      d.blank_line
      d.note "U", title: "Request Users",      items: act.(req_users)
      d.note "D", title: "Request Devices",    items: act.(req_devices)
      d.note "S", title: "Request Services",   items: act.(req_services)
      d.note "M", title: "Request Middleware",  items: act.(req_middlewares)
      d.note "P", title: "Request Providers",   items: act.(req_providers)
    end
  end

  def build_puml_response(res_providers, res_middlewares, res_services, res_devices, res_users)
    act = ->(col) { col.select(&:active).map(&:name) }

    build_sequence_diagram do |d|
      d.participant "Provider",   as: "P"
      d.participant "Middleware",  as: "M"
      d.participant "Service",    as: "S"
      d.participant "Device",     as: "D"
      d.participant "User",       as: "U"

      d.blank_line
      d.message "P", "M", "Provider response",  style: :dashed
      d.message "M", "S", "Processed response",  style: :dashed
      d.message "S", "D", "Service result",       style: :dashed
      d.message "D", "U", "Final response",       style: :dashed

      d.blank_line
      d.note "P", title: "Response Providers",   items: act.(res_providers)
      d.note "M", title: "Response Middleware",  items: act.(res_middlewares)
      d.note "S", title: "Response Services",   items: act.(res_services)
      d.note "D", title: "Response Devices",    items: act.(res_devices)
      d.note "U", title: "Response Users",      items: act.(res_users)
    end
  end
end
