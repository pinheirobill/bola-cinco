class Championship < ApplicationRecord
  ScorerEntry = Struct.new(:athlete_id, :name, :team_name, :goals, keyword_init: true)

  COMPETITION_MODES = {
    "pontuacao" => "Pontuação por chaves",
    "mata_mata" => "Mata-mata eliminatório"
  }.freeze

  TIEBREAKER_OPTIONS = {
    "vitorias" => "Vitórias",
    "saldo_gols" => "Saldo de gols",
    "gols_pro" => "Gols pró",
    "confronto_direto" => "Confronto direto",
    "menos_gols_sofridos" => "Menos gols sofridos",
    "sorteio" => "Sorteio"
  }.freeze

  has_many :categories, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :standing_rows, dependent: :destroy
  has_many :invoices, dependent: :destroy

  enum :status, {
    rascunho: "rascunho",
    inscricoes_abertas: "inscricoes_abertas",
    em_andamento: "em_andamento",
    finalizado: "finalizado"
  }, default: :rascunho

  validates :source_id, :name, :season, presence: true
  validates :source_id, uniqueness: true

  def rules_data
    rules.presence || {}
  end

  def scoring_data
    default_scoring.deep_merge(scoring.presence || {})
  end

  def format_data
    default_format.deep_merge(format.presence || {})
  end

  def tiebreakers
    Array(scoring_data.fetch("tiebreakers", default_scoring.fetch("tiebreakers")))
  end

  def tiebreaker_labels
    tiebreakers.map { |key| TIEBREAKER_OPTIONS[key.to_s] || key.to_s.humanize }
  end

  def competition_mode_label
    COMPETITION_MODES[format_data["mode"].to_s] || "Pontuação por chaves"
  end

  def default_scoring
    {
      "win" => 3,
      "draw" => 1,
      "loss" => 0,
      "wo" => -1,
      "woScore" => 2,
      "qualifiedPerGroup" => 4,
      "tiebreakers" => %w[vitorias saldo_gols gols_pro confronto_direto menos_gols_sofridos sorteio]
    }
  end

  def default_format
    {
      "mode" => "pontuacao",
      "teamCount" => categories.sum { |category| category.teams.size },
      "groupCount" => [categories.size, 1].max
    }
  end

  def completed_matches
    matches.includes(:team_a, :team_b, :winner, :category).where(status: %w[finalizado wo]).order(scheduled_on: :desc, id: :desc)
  end

  def recent_matches(limit = 8)
    matches.includes(:team_a, :team_b, :winner, :category).order(scheduled_on: :desc, id: :desc).limit(limit)
  end

  def standings_by_category
    standing_rows.includes(:team, :category).order(:category_id, position: :asc, points: :desc, goal_diff: :desc, goals_for: :desc).group_by(&:category)
  end

  def top_scorers(limit = 5)
    totals = Hash.new(0)

    completed_matches.each do |match|
      match.scorers.to_h.each do |athlete_id, goals|
        totals[athlete_id.to_s] += goals.to_i
      end
    end

    totals.sort_by { |_athlete_id, goals| -goals }.first(limit).map do |athlete_id, goals|
      athlete = Athlete.includes(:team).find_by(source_id: athlete_id)
      ScorerEntry.new(
        athlete_id: athlete_id,
        name: athlete&.name || athlete_id,
        team_name: athlete&.team&.name || "Sem equipe vinculada",
        goals: goals
      )
    end
  end

  def best_defense_row
    standing_rows.includes(:team, :category).order(goals_against: :asc, goal_diff: :desc, points: :desc).first
  end

  def worst_defense_row
    standing_rows.includes(:team, :category).order(goals_against: :desc, goal_diff: :asc, points: :asc).first
  end
end
