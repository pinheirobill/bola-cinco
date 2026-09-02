class Tranca::HomeController < ApplicationController
  skip_before_action :authenticate_user!
  layout "tranca"

  def index
    @championships = championships_for_modality(:tranca)
    @championship = @championships.first
    @stats = {
      total_maos: 0,
      total_finalizadas: 0,
      total_mata_mata: 0,
      total_rodadas_mata_mata: 0,
      top_dupla: nil,
      top_points: 0
    }
    @knockout_rounds = []
    @knockout_partidas = []
    return unless @championship.present?

    dashboard = Tranca::Dashboard.new(@championship)
    @current_round = dashboard.rodadas.first&.label || "Rodada inicial"
    @live_matches = dashboard.live_partidas
    @recent_results = dashboard.recent_results
    @standings = dashboard.classificacao_rows.first(3)
    @upcoming_matches = dashboard.upcoming_partidas
    @knockout_rounds = dashboard.knockout_rounds
    @knockout_partidas = dashboard.knockout_partidas
    @stats = dashboard.stats
  end
end
