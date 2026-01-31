class AddFlowChainForeignKeys < ActiveRecord::Migration[8.1]
  def change
    add_reference :request_devices,      :request_user,       foreign_key: true
    add_reference :request_services,     :request_device,     foreign_key: true
    add_reference :request_middlewares,   :request_service,    foreign_key: true
    add_reference :request_providers,    :request_middleware,  foreign_key: true
    add_reference :response_providers,   :request_provider,   foreign_key: true
    add_reference :response_middlewares,  :response_provider,  foreign_key: true
    add_reference :response_services,    :response_middleware, foreign_key: true
    add_reference :response_devices,     :response_service,   foreign_key: true
    add_reference :response_users,       :response_device,    foreign_key: true
  end
end
