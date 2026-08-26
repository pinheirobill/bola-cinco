Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  get "dashboard", to: "dashboard#index"

  resources :categories, only: %i[index show]
  resources :entities, only: %i[index show]
  resources :teams, only: %i[index show create update destroy] do
    resources :team_memberships, only: %i[index create]
    resources :team_athletes, only: %i[create destroy]
  end
  resources :team_memberships, only: :destroy
  resources :athletes, only: %i[index show create update destroy] do
    get :card, on: :member, path: "carteirinha"
    resources :team_links, only: %i[create destroy], controller: "athlete_team_links"
  end
  resources :championships, only: %i[index show update] do
    get :setup, on: :member, path: "configuracao"
    resource :team_signup, only: %i[new create], path: "inscricao-time", controller: "championship_team_signups"
    resource :athlete_signup, only: %i[new create], path: "inscricao-atleta", controller: "championship_athlete_signups"
    resources :championship_memberships, only: %i[index create]
  end
  resources :championship_memberships, only: :destroy
  resource :team_panel, only: :show, path: "painel-do-time"
  resource :active_championship, only: %i[show create destroy], path: "campeonato-ativo"
  resources :standing_rows, only: :index, path: "classificacao"
  resources :invoices, only: %i[index show]
  resources :venues, only: %i[index show create update destroy] do
    patch :attach, on: :member
    patch :detach, on: :member
  end
  resources :referees, only: %i[index show create update destroy] do
    patch :attach, on: :member
    patch :detach, on: :member
  end
  resources :news_items, only: %i[index show create update destroy]
  resources :partners, only: %i[index show create update destroy]
  resources :matches, only: %i[index show edit update] do
    resources :match_reports, only: %i[index create]
    resources :match_events, only: %i[index create], shallow: true
    resources :match_participations, only: %i[create update destroy], shallow: true
  end
  resources :match_events, only: %i[index show update destroy]
  resources :match_reports, only: %i[index show update destroy]
  resources :suspensions, only: %i[index show create update destroy]
  resource :championship_engagement, only: :show, path: "engajamento"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

end
