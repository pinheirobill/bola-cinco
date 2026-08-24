Rails.application.routes.draw do
  devise_for :users
  root "dashboard#index"

  resources :championships, only: %i[index show update]
  resources :categories, only: %i[index show]
  resources :entities, only: %i[index show]
  resources :teams, only: %i[index show]
  resources :athletes, only: %i[index show]
  resources :matches, only: %i[index show]
  resources :standing_rows, only: :index, path: "classificacao"
  resources :invoices, only: %i[index show]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

end
