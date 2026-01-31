class DashboardController < ApplicationController
  layout "inertia", only: [:show]

  def show
    # Request flow (forward)
    req_users       = RequestUser.all
    req_devices     = RequestDevice.all
    req_services    = RequestService.all
    req_middlewares = RequestMiddleware.all.order(:position)
    req_providers   = RequestProvider.all

    # Response flow (reverse)
    res_providers   = ResponseProvider.all
    res_middlewares = ResponseMiddleware.all.order(:position)
    res_services    = ResponseService.all
    res_devices     = ResponseDevice.all
    res_users       = ResponseUser.all

    puml = build_puml(
      req_users, req_devices, req_services, req_middlewares, req_providers,
      res_providers, res_middlewares, res_services, res_devices, res_users
    )

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

    render inertia: "Dashboard/Show", props: {
      puml: puml,
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
      recent_ingestions: recent_ingestions
    }
  end

  private

  def layer_summary(records, type_field)
    {
      total: records.size,
      active: records.count(&:active),
      by_type: records.group_by(&type_field).transform_values(&:count)
    }
  end

  def build_puml(req_users, req_devices, req_services, req_middlewares, req_providers,
                 res_providers, res_middlewares, res_services, res_devices, res_users)
    act = ->(col) { col.select(&:active).map(&:name) }

    <<~PUML
      @startuml
      skinparam backgroundColor #FEFEFE
      skinparam sequenceArrowThickness 2
      skinparam roundcorner 10
      skinparam sequenceParticipantBorderColor #4F46E5
      skinparam sequenceArrowColor #6366F1
      skinparam sequenceLifeLineBorderColor #A5B4FC
      skinparam noteBorderColor #C7D2FE
      skinparam noteBackgroundColor #EEF2FF

      participant "User" as U
      participant "Device" as D
      participant "Service" as S
      participant "Middleware" as M
      participant "Provider" as P

      == Request Flow ==
      U -> D : Select device
      D -> S : Route to service
      S -> M : Apply middleware
      M -> P : Fulfill request

      note over U
        **Request Users**
        #{act.(req_users).join("\\n")}
      end note

      note over D
        **Request Devices**
        #{act.(req_devices).join("\\n")}
      end note

      note over S
        **Request Services**
        #{act.(req_services).join("\\n")}
      end note

      note over M
        **Request Middleware**
        #{act.(req_middlewares).join("\\n")}
      end note

      note over P
        **Request Providers**
        #{act.(req_providers).join("\\n")}
      end note

      == Response Flow ==
      P --> M : Provider response
      M --> S : Processed response
      S --> D : Service result
      D --> U : Final response

      note over P
        **Response Providers**
        #{act.(res_providers).join("\\n")}
      end note

      note over M
        **Response Middleware**
        #{act.(res_middlewares).join("\\n")}
      end note

      note over S
        **Response Services**
        #{act.(res_services).join("\\n")}
      end note

      note over D
        **Response Devices**
        #{act.(res_devices).join("\\n")}
      end note

      note over U
        **Response Users**
        #{act.(res_users).join("\\n")}
      end note

      @enduml
    PUML
  end
end
