class StandingRowsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    grouped_rows = scoped_standing_rows.includes(:category, :team, :championship).order(:category_id, :group_key, position: :asc, points: :desc, goal_diff: :desc)
    @standing_groups = grouped_rows.group_by { |row| [row.category, row.group_key.to_s] }.map do |(category, group_key), rows|
      Championship::StandingGroup.new(category: category, group_key: group_key, rows: rows)
    end.sort_by { |group| [group.category.name.to_s.downcase, group.group_key.to_s.downcase] }

    @highlight_championship = current_championship
    load_football_highlights if @highlight_championship.present? && !@highlight_championship.tranca?
  end

  def create
    championship = scoped_championship
    return forbidden! if championship.blank?
    return forbidden! unless current_user&.admin? || championship.manageable_by?(current_user)

    category = championship.categories.find(standing_row_params[:category_id])
    team = championship.teams.find(standing_row_params[:team_id])
    record = championship.standing_rows.new(standing_row_params.except(:championship_id).merge(category: category, team: team))

    if record.save
      sync_tranca_classificacao_row_from_standing_row(record)
      redirect_back fallback_location: standing_rows_path, notice: "Linha de classificação criada."
    else
      redirect_back fallback_location: standing_rows_path, alert: record.errors.full_messages.to_sentence
    end
  end

  def update
    record = scoped_standing_rows.find(params[:id])
    return forbidden! unless current_user&.admin? || record.championship.manageable_by?(current_user)

    category = record.championship.categories.find(standing_row_params[:category_id])
    team = record.championship.teams.find(standing_row_params[:team_id])

    if record.update(standing_row_params.except(:championship_id).merge(category: category, team: team))
      sync_tranca_classificacao_row_from_standing_row(record)
      redirect_back fallback_location: standing_rows_path, notice: "Linha de classificação atualizada."
    else
      redirect_back fallback_location: standing_rows_path, alert: record.errors.full_messages.to_sentence
    end
  end

  def destroy
    record = scoped_standing_rows.find(params[:id])
    return forbidden! unless current_user&.admin? || record.championship.manageable_by?(current_user)

    destroy_tranca_classificacao_row_from_standing_row(record)
    record.destroy!
    redirect_back fallback_location: standing_rows_path, notice: "Linha de classificação removida."
  end

  private

  def scoped_standing_rows
    return StandingRow.includes(:category, :team, :championship) if current_user&.admin?
    return StandingRow.where(championship_id: current_championship.id) if current_championship.present?

    StandingRow.none
  end

  def scoped_championship
    championship_id = params.dig(:standing_row, :championship_id).presence
    return Championship.find_by(id: championship_id) if championship_id.present?

    return current_championship if current_championship.present?

    Championship.order(season: :desc, created_at: :desc).first
  end

  def load_football_highlights
    @highlight_standing_rows = @highlight_championship.standing_rows.includes(:team, :category).to_a
    played_rows = @highlight_standing_rows.select { |row| row.played.to_i.positive? }
    @most_goals_row = played_rows.max_by do |row|
      [row.goals_for.to_i, row.goal_diff.to_i, row.points.to_i, -row.position.to_i]
    end

    card_totals = Hash.new { |hash, team_id| hash[team_id] = { yellow: 0, red: 0 } }
    completed_matches = @highlight_championship.completed_matches.includes(match_events: :team).to_a
    completed_matches.each do |match|
      match.match_events.each do |event|
        next if event.team_id.blank?

        case event.kind
        when "cartao_amarelo"
          card_totals[event.team_id][:yellow] += 1
        when "cartao_vermelho"
          card_totals[event.team_id][:red] += 1
        end
      end
    end

    @fewest_cards_row = played_rows.min_by do |row|
      totals = card_totals[row.team_id]
      [totals[:yellow] + totals[:red], totals[:red], -row.points.to_i, row.team.name.to_s.downcase]
    end
    @fewest_cards_total = if @fewest_cards_row.present?
      totals = card_totals[@fewest_cards_row.team_id]
      totals[:yellow] + totals[:red]
    end
    @fewest_cards_yellow = @fewest_cards_row.present? ? card_totals[@fewest_cards_row.team_id][:yellow] : 0
    @fewest_cards_red = @fewest_cards_row.present? ? card_totals[@fewest_cards_row.team_id][:red] : 0
    @highlight_top_scorers = @highlight_championship.top_scorers(5)
    @completed_match_count = completed_matches.size
    @completed_goal_count = completed_matches.sum { |match| match.score_a.to_i + match.score_b.to_i }
  end

  def standing_row_params
    params.expect(standing_row: [
      :championship_id,
      :category_id,
      :team_id,
      :group_key,
      :position,
      :played,
      :wins,
      :draws,
      :losses,
      :goals_for,
      :goals_against,
      :goal_diff,
      :points,
      :qualified
    ])
  end

  def sync_tranca_classificacao_row_from_standing_row(record)
    tranca_dupla = Tranca::Dupla.find_by(source_id: record.team.source_id)
    return if tranca_dupla.blank?

    tranca_row = Tranca::ClassificacaoRow.find_or_initialize_by(source_id: tranca_classificacao_source_id(record))
    tranca_row.assign_attributes(
      championship: record.championship,
      category: record.category,
      tranca_dupla: tranca_dupla,
      group_key: record.group_key,
      position: record.position,
      played: record.played,
      wins: record.wins,
      draws: record.draws,
      losses: record.losses,
      goals_for: record.goals_for,
      goals_against: record.goals_against,
      goal_diff: record.goal_diff,
      points: record.points,
      qualified: record.qualified
    )
    tranca_row.save!
  end

  def destroy_tranca_classificacao_row_from_standing_row(record)
    Tranca::ClassificacaoRow.find_by(source_id: tranca_classificacao_source_id(record))&.destroy!
  end

  def tranca_classificacao_source_id(record)
    "tranca-standing-row-#{record.id}"
  end
end
