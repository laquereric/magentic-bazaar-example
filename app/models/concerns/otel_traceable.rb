module OtelTraceable
  extend ActiveSupport::Concern

  included do
    class_attribute :otel_config, default: {}

    after_create  :otel_emit_lifecycle_event, if: :otel_tracing_enabled?
    after_update  :otel_emit_lifecycle_event, if: :otel_tracing_enabled?
    after_destroy :otel_emit_lifecycle_event, if: :otel_tracing_enabled?
  end

  class_methods do
    def otel_service_name(name)
      self.otel_config = otel_config.merge(service_name: name)
    end

    def otel_layer_role(role)
      self.otel_config = otel_config.merge(layer_role: role)
    end

    def otel_flow(direction, position:)
      self.otel_config = otel_config.merge(flow: direction, position: position)
    end
  end

  def otel_span(name, &block)
    tracer = OpenTelemetry.tracer_provider.tracer(
      self.class.otel_config[:service_name] || self.class.name
    )

    tracer.in_span(name, attributes: otel_span_attributes) do |span|
      block.call(span)
    end
  end

  def otel_span_attributes
    attrs = {
      "otel.service_name" => self.class.otel_config[:service_name],
      "otel.layer_role"   => self.class.otel_config[:layer_role].to_s,
      "otel.flow"         => self.class.otel_config[:flow].to_s,
      "otel.position"     => self.class.otel_config[:position],
      "model.class"       => self.class.name,
      "model.id"          => id
    }

    attrs["model.name"]   = name   if respond_to?(:name)
    attrs["model.active"] = active if respond_to?(:active)
    attrs["model.status"] = status if respond_to?(:status)

    attrs.compact
  end

  def otel_record_latency(ms)
    current_span = OpenTelemetry::Trace.current_span
    return unless current_span.recording?

    current_span.add_event("latency", attributes: { "duration_ms" => ms.to_f })
  end

  def otel_record_cost(amount)
    current_span = OpenTelemetry::Trace.current_span
    return unless current_span.recording?

    current_span.add_event("cost", attributes: { "amount" => amount.to_f })
  end

  def otel_record_error(exception_or_msg)
    current_span = OpenTelemetry::Trace.current_span
    return unless current_span.recording?

    if exception_or_msg.is_a?(Exception)
      current_span.record_exception(exception_or_msg)
    else
      current_span.add_event("error", attributes: { "message" => exception_or_msg.to_s })
    end

    current_span.status = OpenTelemetry::Trace::Status.error(exception_or_msg.to_s)
  end

  def otel_metadata
    {
      service_name: self.class.otel_config[:service_name],
      layer_role:   self.class.otel_config[:layer_role],
      flow:         self.class.otel_config[:flow],
      position:     self.class.otel_config[:position],
      model_class:  self.class.name,
      model_id:     id,
      trace_id:     try(:otel_trace_id)
    }.compact
  end

  def otel_stamp_trace_id
    trace_id = OpenTelemetry::Trace.current_span.context.hex_trace_id
    update_column(:otel_trace_id, trace_id) if has_attribute?(:otel_trace_id)
  end

  private

  def otel_tracing_enabled?
    self.class.otel_config[:service_name].present?
  end

  def otel_emit_lifecycle_event
    action = if destroyed?
               "destroy"
             elsif previously_new_record?
               "create"
             else
               "update"
             end

    current_span = OpenTelemetry::Trace.current_span
    return unless current_span.recording?

    current_span.add_event(
      "#{self.class.otel_config[:service_name]}.#{action}",
      attributes: otel_span_attributes.transform_values(&:to_s)
    )
  end
end
