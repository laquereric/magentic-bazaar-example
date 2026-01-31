class AddOtelTraceIdToFlowTables < ActiveRecord::Migration[8.1]
  def change
    %i[
      request_users
      request_devices
      request_services
      request_middlewares
      request_providers
      response_providers
      response_middlewares
      response_services
      response_devices
      response_users
    ].each do |table|
      add_column table, :otel_trace_id, :string
      add_index  table, :otel_trace_id
    end
  end
end
