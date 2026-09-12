Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }
  root "home#index"
  get "dashboard", to: redirect("/")

  devise_scope :user do
    namespace :football do
      root "home#index"
      get "login", to: "/users/sessions#new", defaults: { portal: "football" }, as: :login
    end

    namespace :tranca do
      root "home#index"
      get "login", to: "/users/sessions#new", defaults: { portal: "tranca" }, as: :login
    end
  end

  resources :categories, only: %i[index show update]
  resources :categories, only: [] do
    post :duplicate, on: :member, path: "duplicar"
  end
  resources :entities, only: %i[index show]
  resources :teams, only: %i[index show edit create update destroy] do
    resources :team_memberships, only: %i[index create]
    resources :team_athletes, only: %i[create destroy]
    patch :confirm_registration, on: :member, path: "confirmar-inscricao"
    patch :reject_registration, on: :member, path: "rejeitar-inscricao"
  end
  resources :team_memberships, only: :destroy
  resources :athletes, only: %i[index show create update destroy] do
    get :card, on: :member, path: "carteirinha"
    resources :team_links, only: %i[create destroy], controller: "athlete_team_links"
  end
  resources :championships, only: %i[index new create show update] do
    get :setup, on: :member, path: "configuracao"
    get :duplas, on: :member, path: "duplas"
    resource :dupla_import, only: %i[new create], controller: "tranca/dupla_imports", path: "duplas/importar" do
      post :preview
      get "preview", action: :restart_preview, as: :restart_preview
      get :template
    end
    get :partidas, on: :member, path: "partidas"
    get :rodadas, on: :member, path: "rodadas"
    get :programacao, on: :member, path: "programacao"
    get :programacao_telao, on: :member, path: "programacao/telao"
    get "rodadas/:rodada_id/sumulas", to: "tranca/round_exports#summulas", as: :round_summulas
    get "rodadas/:rodada_id/jogos.xlsx", to: "tranca/round_exports#games", as: :round_games
    get "jogos.xlsx", to: "tranca/round_exports#all_games", as: :tranca_games
    get :classificacao, on: :member, path: "classificacao"
    post :generate_tranca_round, on: :member, path: "tranca/gerar-rodada"
    post :select_tranca_knockout_duplas, on: :member, path: "tranca/selecionar-mata-mata"
    post :generate_tranca_mesas, on: :member, path: "tranca/gerar-mesas"
    delete :destroy_tranca_round, on: :member, path: "rodadas/:rodada_id"
    patch :update_tranca_partida, on: :member, path: "tranca/partidas/:partida_id"
    delete :destroy_tranca_partida, on: :member, path: "tranca/partidas/:partida_id"
    get :download_tranca_summula, on: :member, path: "tranca/partidas/:partida_id/sumula"
    get :download_complete_tranca_summula, on: :member, path: "tranca/partidas/:partida_id/sumula-completa"
    get :import_tranca_summula, on: :member, path: "tranca/partidas/:partida_id/importar-sumula"
    post :import_tranca_summula, on: :member, path: "tranca/partidas/:partida_id/importar-sumula"
    patch :rebuild_tranca_classificacao, on: :member, path: "tranca/classificacao/recalcular"
    patch :finalize_onboarding, on: :member, path: "concluir-onboarding"
    patch :finalize_registrations, on: :member, path: "finalizar-inscricoes"
    patch :attach_category, on: :member, path: "vincular-categoria"
    patch :detach_category, on: :member, path: "remover-categoria"
    post :draw_knockout_round, on: :member, path: "sortear-primeira-rodada"
    post :invite_recent_tranca_duplas, on: :member, path: "tranca/convidar-duplas"
    patch :attach_team, on: :member, path: "vincular-time"
    patch :confirm_all_team_registrations, on: :member, path: "confirmar-todas-inscricoes"
    patch :attach_partner, on: :member, path: "vincular-parceiro"
    resource :team_signup, only: %i[new create], path: "inscricao-time", controller: "championship_team_signups"
    resource :athlete_signup, only: %i[new create], path: "inscricao-atleta", controller: "championship_athlete_signups"
    resources :championship_memberships, only: %i[index create]
  end
  resources :championship_memberships, only: :destroy
  resource :team_panel, only: :show, path: "painel-do-time"
  resource :active_championship, only: %i[show create destroy], path: "campeonato-ativo"
  resources :standing_rows, only: %i[index create update destroy], path: "classificacao"
  resources :invoices, only: %i[index show]
  resource :theme_preference, only: :update
  resources :venues, only: %i[index show create update destroy] do
    patch :attach, on: :member
    patch :detach, on: :member
  end
  resources :referees, only: %i[index show create update destroy] do
    patch :attach, on: :member
    patch :detach, on: :member
  end
  resources :partners, only: %i[index show create update destroy]
  resources :matches, only: %i[index show edit update create] do
    post :import_summula, on: :member, path: "importar-sumula"
    resources :match_reports, only: %i[index create]
    resources :match_events, only: %i[index create], shallow: true
    resources :match_participations, only: %i[create update destroy], shallow: true
  end
  resources :match_events, only: %i[index show create update destroy]
  resources :match_reports, only: %i[index show update destroy] do
    patch :approve, on: :member
  end
  resources :suspensions, only: %i[index show create update destroy]
  resource :championship_engagement, only: :show, path: "engajamento"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
