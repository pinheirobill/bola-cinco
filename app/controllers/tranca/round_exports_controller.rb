class Tranca::RoundExportsController < ApplicationController
  before_action :load_round

  def summulas
    send_data BolaCinco::TrancaSummulaDocument.render_all(@matches),
      filename: "#{export_name}-sumulas.pdf", type: "application/pdf", disposition: "attachment"
  end

  def games
    send_data Tranca::RoundGamesSpreadsheet.new(@round, @matches).render,
      filename: "#{export_name}-jogos.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", disposition: "attachment"
  end

  private

  def load_round
    identifier = params[:championship_id].to_s
    @championship = Championship.find_by(slug: identifier) || Championship.find_by(id: identifier[/\A\d+/])
    raise ActiveRecord::RecordNotFound unless @championship&.tranca?
    return forbidden! unless @championship.manageable_by?(current_user) || @championship.visible_by?(current_user) || @championship.publicly_visible? || current_user&.admin?

    @round = @championship.tranca_rodadas.find(params[:rodada_id])
    @matches = @round.partidas.includes(:championship, :category, :dupla_a, :dupla_b, :tranca_mesa, :maos).order(:category_id, :id).to_a
    if @matches.empty?
      redirect_to rodadas_championship_path(@championship), alert: "Esta rodada ainda não tem jogos."
    end
  end

  def export_name
    "#{@championship.name.parameterize}-#{@round.phase.parameterize}-rodada-#{@round.round_number}"
  end
end
