Rails.application.routes.draw do
  root "dashboard#show"

  resource :session
  resource :registration, only: [ :new, :create ]
  resources :passwords, param: :token

  resources :documents, only: [ :index, :show ]
  resources :uml_diagrams, only: [ :index, :show ], path: "uml"
  resources :skills, only: [ :index, :show ]
  resources :uploads, only: [ :new, :create ]

  namespace :admin do
    root "dashboard#show"
    resources :ingestions, only: [ :index, :show, :create ] do
      post :undo, on: :member
    end
    resource :configuration, only: [ :show, :update ]
    resources :users, only: [ :index, :update ]
    resource :system_status, only: [ :show ], path: "status"

    resource :llm, only: [ :show ], controller: "llm" do
      post :seed, on: :member
    end
    resources :llm_providers do
      post :test, on: :member
      resources :llm_model_configurations, only: [ :new, :create ]
    end
    resources :llm_model_configurations, only: [ :edit, :update, :destroy ]
    resources :mcp_servers
    resources :mcp_providers
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
