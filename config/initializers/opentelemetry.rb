require "opentelemetry/sdk"
require "opentelemetry-exporter-otlp"

OpenTelemetry::SDK.configure do |c|
  version = File.read(Rails.root.join("VERSION")).strip rescue "0.0.0"

  c.service_name = "magentic-bazaar-example"
  c.service_version = version

  c.use "OpenTelemetry::Instrumentation::Rails"
  c.use "OpenTelemetry::Instrumentation::ActiveRecord"

  if ENV["OTEL_EXPORTER_OTLP_ENDPOINT"].present?
    c.add_span_processor(
      OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new(
        OpenTelemetry::Exporter::OTLP::Exporter.new
      )
    )
  elsif Rails.env.development?
    c.add_span_processor(
      OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(
        OpenTelemetry::SDK::Trace::Export::ConsoleSpanExporter.new
      )
    )
  end
end
