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
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
