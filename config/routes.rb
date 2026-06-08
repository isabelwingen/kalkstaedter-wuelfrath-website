Rails.application.routes.draw do
  # Auth
  resource :session
  resources :passwords, param: :token

  get "up" => "rails/health#show", as: :rails_health_check

  # Öffentliche Seiten
  root "home#index"

  resources :events, only: [ :index, :show ]
  resources :posts, only: [ :index, :show ]
  resources :press_links, only: [ :index ]

  # Statische Vereinsseiten
  get "ueber-uns",  to: "static_pages#ueber_uns",  as: :ueber_uns
  get "mitmachen",  to: "static_pages#mitmachen",  as: :mitmachen
  get "musikschule", to: "static_pages#musikschule", as: :musikschule
  get "chronik",    to: "static_pages#chronik",    as: :chronik
  get "impressum",  to: "static_pages#impressum",  as: :impressum
  get "datenschutz", to: "static_pages#datenschutz", as: :datenschutz

  # Admin-Bereich
  get "admin/login", to: "sessions#new", as: :admin_login

  namespace :admin do
    root "dashboard#index"

    resources :events
    resources :posts
    resources :press_links
    resources :info_channels
    resources :static_pages, only: %i[index edit update]
    resource :site_settings, only: [ :edit, :update ]
    post "text_improvements", to: "text_improvements#create"
  end
end
