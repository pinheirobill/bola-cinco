class Tranca::RoundExportsController < ApplicationController
  before_action :load_round
  skip_before_action :load_round, only: :all_games

  def summulas
    send_data BolaCinco::TrancaSummulaDocument.render_all(@matches),
      filename: "#{export_name}-sumulas.pdf", type: "application/pdf", disposition: "attachment"
  end

  def games
    sort = export_sort
    send_data Tranca::RoundGamesSpreadsheet.new(@round, @matches, order: sort).render,
      filename: "#{export_name}-jogos-por-#{sort == :name ? 'nome' : 'mesa'}.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", disposition: "attachment"
  end

  def all_games
    load_championship
    matches = @championship.tranca_partidas.includes(:championship, :category, :dupla_a, :dupla_b, :tranca_mesa, :maos)
      .order(:phase, :round_number, :category_id, :id).to_a
    return redirect_to classificacao_championship_path(@championship), alert: "Este campeonato ainda não tem jogos." if matches.empty?

    sort = export_sort
    send_data Tranca::RoundGamesSpreadsheet.new(nil, matches, order: sort).render,
      filename: "#{@championship.name.parameterize}-jogos-por-#{sort == :name ? 'nome' : 'mesa'}.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", disposition: "attachment"
  end

  private

  def load_round
    load_championship

    @round = @championship.tranca_rodadas.find(params[:rodada_id])
    @matches = @round.partidas.includes(:championship, :category, :dupla_a, :dupla_b, :tranca_mesa, :maos).order(:category_id, :id).to_a
    if @matches.empty?
      redirect_to rodadas_championship_path(@championship), alert: "Esta rodada ainda não tem jogos."
    end
  end

  def load_championship
    identifier = params[:championship_id].to_s
    @championship = Championship.find_by(slug: identifier) || Championship.find_by(id: identifier[/\A\d+/])
    raise ActiveRecord::RecordNotFound unless @championship&.tranca?
    forbidden! unless @championship.manageable_by?(current_user) || @championship.visible_by?(current_user) || @championship.publicly_visible? || current_user&.admin?
  end

  def export_name
    "#{@championship.name.parameterize}-#{@round.phase.parameterize}-rodada-#{@round.round_number}"
  end

  def export_sort
    params[:order].to_s == "name" ? :name : :mesa
  end
end
