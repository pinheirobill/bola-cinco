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

  REGISTRATION_FORM_FIELDS = {
    "apelido" => "Apelido",
    "foto" => "Foto",
    "cpf" => "CPF",
    "rg" => "RG",
    "certidao_nascimento" => "Cert. de Nasc.",
    "data_nascimento" => "Data de Nasc.",
    "posicao" => "Posição",
    "numero_camisa" => "Nº da camisa",
    "celular" => "Celular",
    "email" => "E-mail",
    "passaporte" => "Passaporte",
    "titulo_eleitor" => "Título de eleitor",
    "genero" => "Gênero",
    "documentos_anexo" => "Documentos em anexo"
  }.freeze

  REGISTRATION_REQUIREMENT_OPTIONS = {
    "informar" => "Informar",
    "pede" => "Pedir",
    "obrigatorio" => "Obrigatório"
  }.freeze

  PRINTED_SUMMARY_FIELDS = {
    "cpf" => "CPF",
    "rg" => "RG",
    "data_nascimento" => "Data de Nasc."
  }.freeze

  has_many :championship_categories, dependent: :delete_all
  has_many :categories, through: :championship_categories
  has_many :teams, through: :categories
  has_many :athletes, through: :categories
  has_many :matches, dependent: :destroy
  has_many :standing_rows, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :venues, dependent: :nullify
  has_many :referees, dependent: :nullify
  has_many :partners, dependent: :destroy
  has_many :championship_memberships, dependent: :destroy
  has_many :users, through: :championship_memberships
  has_many :match_events, dependent: :destroy
  has_many :match_reports, through: :matches
  has_many :suspensions, dependent: :destroy

  enum :status, {
    rascunho: "rascunho",
    inscricoes_abertas: "inscricoes_abertas",
    em_andamento: "em_andamento",
    finalizado: "finalizado"
  }, default: :rascunho

  validates :source_id, :name, :season, presence: true
  validates :source_id, uniqueness: true
  validates :slug, uniqueness: true, allow_blank: true
  before_validation :assign_slug, on: :create

  scope :publicly_visible, -> { where.not(status: :rascunho) }

  def rules_data
    default_rules.deep_merge(rules.presence || {})
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

  def registration_data
    rules_data.fetch("registration", {})
  end

  def max_athletes_per_team
    registration_data.fetch("max_athletes_per_team", 0).to_i
  end

  def max_staff_members_per_team
    registration_data.fetch("max_staff_members_per_team", 0).to_i
  end

  def athlete_action_enabled?(action)
    ActiveModel::Type::Boolean.new.cast(registration_data.dig("athlete_actions", action.to_s))
  end

  def team_signup_enabled?
    ActiveModel::Type::Boolean.new.cast(registration_data.dig("team_signups", "enabled"))
  end

  def team_signup_open?
    team_signup_enabled?
  end

  def athlete_registration_open?
    athlete_action_enabled?("allow_register")
  end

  def athlete_editing_open?
    athlete_action_enabled?("allow_edit")
  end

  def athlete_removal_open?
    athlete_action_enabled?("allow_remove")
  end

  def athlete_form_requirement(field)
    registration_data.dig("athlete_form", field.to_s).presence || "informar"
  end

  def printed_summary_field
    registration_data.fetch("printed_summary_field", "cpf")
  end

  def required_athlete_fields
    registration_data.fetch("athlete_form", {}).select { |_field, requirement| requirement.to_s == "obrigatorio" }.keys
  end

  def athlete_field_required?(field)
    athlete_form_requirement(field) == "obrigatorio"
  end

  def athlete_limit_reached_for?(team)
    max_athletes = max_athletes_per_team
    max_athletes.positive? && team.athletes.count >= max_athletes
  end

  def staff_limit_reached_for?(team)
    max_staff = max_staff_members_per_team
    max_staff.positive? && team.team_memberships.status_ativo.where(role: %w[tecnico capitao responsavel]).count >= max_staff
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

  def default_rules
    {
      "registration" => {
        "max_athletes_per_team" => 18,
        "max_staff_members_per_team" => 5,
        "athlete_actions" => {
          "allow_register" => true,
          "allow_edit" => true,
          "allow_remove" => false
        },
        "team_signups" => {
          "enabled" => true,
          "status" => "inscricoes_abertas"
        },
        "athlete_form" => {
          "apelido" => "obrigatorio",
          "foto" => "informar",
          "cpf" => "obrigatorio",
          "rg" => "informar",
          "certidao_nascimento" => "informar",
          "data_nascimento" => "obrigatorio",
          "posicao" => "obrigatorio",
          "numero_camisa" => "obrigatorio",
          "celular" => "obrigatorio",
          "email" => "obrigatorio",
          "passaporte" => "informar",
          "titulo_eleitor" => "informar",
          "genero" => "obrigatorio",
          "documentos_anexo" => "informar"
        },
        "printed_summary_field" => "cpf"
      }
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

  AthleteRankingEntry = Struct.new(:athlete_id, :name, :team_name, :goals, :assists, :yellow_cards, :red_cards, :score, keyword_init: true)

  def best_defense_row
    standing_rows.includes(:team, :category).order(goals_against: :asc, goal_diff: :desc, points: :desc).first
  end

  def worst_defense_row
    standing_rows.includes(:team, :category).order(goals_against: :desc, goal_diff: :asc, points: :asc).first
  end

  def top_teams(limit = 5)
    standing_rows.includes(:team, :category)
      .order(points: :desc, goal_diff: :desc, goals_for: :desc, position: :asc)
      .first(limit)
  end

  def top_athletes(limit = 10)
    athlete_stats = Hash.new do |hash, athlete_id|
      hash[athlete_id] = { goals: 0, assists: 0, yellow_cards: 0, red_cards: 0 }
    end

    completed_matches.includes(match_events: %i[athlete team]).each do |match|
      match.match_events.each do |event|
        athlete = event.athlete
        next if athlete.blank?

        stats = athlete_stats[athlete.source_id]
        case event.kind
        when "gol"
          stats[:goals] += 1
        when "assistencia"
          stats[:assists] += 1
        when "cartao_amarelo"
          stats[:yellow_cards] += 1
        when "cartao_vermelho"
          stats[:red_cards] += 1
        end
      end
    end

    athlete_stats.sort_by do |_athlete_id, stats|
      [
        -(stats[:goals] * 10 + stats[:assists] * 4 - stats[:yellow_cards] * 2 - stats[:red_cards] * 6),
        -stats[:goals],
        -stats[:assists]
      ]
    end.first(limit).map do |athlete_id, stats|
      athlete = Athlete.includes(:team).find_by(source_id: athlete_id)
      AthleteRankingEntry.new(
        athlete_id: athlete_id,
        name: athlete&.name || athlete_id,
        team_name: athlete&.team&.name || "Sem equipe vinculada",
        goals: stats[:goals],
        assists: stats[:assists],
        yellow_cards: stats[:yellow_cards],
        red_cards: stats[:red_cards],
        score: stats[:goals] * 10 + stats[:assists] * 4 - stats[:yellow_cards] * 2 - stats[:red_cards] * 6
      )
    end
  end

  def rebuild_standings!
    rebuilt_rows = []

    categories.includes(:teams).find_each do |category|
      team_stats = category.teams.index_by(&:id).transform_values { |team| standing_stats_for(team) }

      classification_matches_for(category).each do |match|
        apply_match_to_standings!(team_stats, match)
      end

      sorted_stats = team_stats.values.sort_by do |stats|
        [
          -stats[:points],
          -stats[:goal_diff],
          -stats[:goals_for],
          -stats[:wins],
          stats[:team].name.to_s.downcase
        ]
      end

      sorted_stats.each_with_index do |stats, index|
        rebuilt_rows << standing_rows.new(
          category: category,
          team: stats[:team],
          position: index + 1,
          played: stats[:played],
          wins: stats[:wins],
          draws: stats[:draws],
          losses: stats[:losses],
          goals_for: stats[:goals_for],
          goals_against: stats[:goals_against],
          goal_diff: stats[:goal_diff],
          points: stats[:points],
          qualified: nil
        )
      end
    end

    transaction do
      standing_rows.delete_all
      rebuilt_rows.each(&:save!)
    end
  end

  def advance_knockout_from!(match)
    return unless match.knockout_phase?
    return if match.round_number.blank?

    knockout_matches = matches
      .includes(:team_a, :team_b, :winner)
      .where(category_id: match.category_id)
      .where.not(round_number: nil)
      .select(&:knockout_phase?)
      .sort_by { |knockout_match| [knockout_match.round_number.to_i, knockout_match.id] }

    rounds = knockout_matches.group_by(&:round_number)
    return if rounds.size < 2

    previous_winners = []

    rounds.keys.sort.each do |round_number|
      round_matches = rounds.fetch(round_number)

      if round_number == rounds.keys.min
        previous_winners = round_matches.map(&:winner).compact
        next
      end

      next_round_teams = previous_winners.dup

      round_matches.each do |round_match|
        next if round_match.score_a.present? || round_match.score_b.present? || round_match.status_wo? || round_match.winner.present?

        round_match.update_columns(
          team_a_id: next_round_teams.shift&.id,
          team_b_id: next_round_teams.shift&.id,
          updated_at: Time.current
        )
      end

      previous_winners = round_matches.map(&:winner).compact
    end
  end

  def draw_initial_knockout_round!
    raise ArgumentError, "campeonato precisa estar em mata-mata" unless format_data["mode"].to_s == "mata_mata"

    created_matches = []

    transaction do
      categories.includes(:teams).find_each do |category|
        next if matches.where(category_id: category.id, phase: "mata_mata", round_number: 1).exists?

        shuffled_teams = category.teams.to_a.shuffle
        next if shuffled_teams.size < 2

        shuffled_teams.each_slice(2).with_index(1) do |pair, index|
          next if pair.size < 2

          created_matches << matches.create!(
            source_id: knockout_match_source_id(category, index),
            category: category,
            code: knockout_match_code(category, index),
            phase: "mata_mata",
            round_number: 1,
            team_a: pair[0],
            team_b: pair[1],
            status: :agendado
          )
        end
      end
    end

    created_matches
  end

  def featured_partners(limit = 6)
    partners.status_ativo.order(highlight: :desc, tier: :asc, created_at: :desc).limit(limit)
  end

  def manageable_by?(user)
    user&.can_manage_championship?(self)
  end

  def visible_by?(user)
    user&.can_view_championship?(self)
  end

  def publicly_visible?
    !rascunho?
  end

  def to_param
    slug.presence || super
  end

  private

  def standing_stats_for(team)
    {
      team: team,
      played: 0,
      wins: 0,
      draws: 0,
      losses: 0,
      goals_for: 0,
      goals_against: 0,
      goal_diff: 0,
      points: 0
    }
  end

  def classification_phase_values
    %w[classificatoria classificatória grupos grupo fase_de_grupos fase-de-grupos]
  end

  def classification_matches_for(category)
    matches
      .includes(:team_a, :team_b, :winner)
      .where(category_id: category.id)
      .where(status: %w[finalizado wo])
      .select(&:classification_phase?)
      .sort_by { |match| [match.scheduled_on || Date.new(1900, 1, 1), match.id] }
  end

  def apply_match_to_standings!(team_stats, match)
    team_a_stats = team_stats[match.team_a_id]
    team_b_stats = team_stats[match.team_b_id]
    return if team_a_stats.blank? || team_b_stats.blank?

    if match.status_wo? && match.winner.present?
      apply_wo_to_standings!(team_a_stats, team_b_stats, match)
      return
    end

    return if match.score_a.blank? || match.score_b.blank?

    team_a_goals = match.score_a.to_i
    team_b_goals = match.score_b.to_i

    team_a_stats[:played] += 1
    team_b_stats[:played] += 1
    team_a_stats[:goals_for] += team_a_goals
    team_a_stats[:goals_against] += team_b_goals
    team_b_stats[:goals_for] += team_b_goals
    team_b_stats[:goals_against] += team_a_goals

    if team_a_goals > team_b_goals
      apply_match_points!(team_a_stats, team_b_stats, scoring_data["win"], scoring_data["loss"])
    elsif team_b_goals > team_a_goals
      apply_match_points!(team_b_stats, team_a_stats, scoring_data["win"], scoring_data["loss"])
    else
      team_a_stats[:draws] += 1
      team_b_stats[:draws] += 1
      team_a_stats[:points] += scoring_data["draw"].to_i
      team_b_stats[:points] += scoring_data["draw"].to_i
    end

    finalize_standing_totals!(team_a_stats)
    finalize_standing_totals!(team_b_stats)
  end

  def apply_wo_to_standings!(team_a_stats, team_b_stats, match)
    return if match.winner.blank?

    winner_stats = match.winner == team_a_stats[:team] ? team_a_stats : team_b_stats
    loser_stats = winner_stats.equal?(team_a_stats) ? team_b_stats : team_a_stats
    wo_score = scoring_data["woScore"].to_i

    winner_stats[:played] += 1
    loser_stats[:played] += 1
    winner_stats[:wins] += 1
    loser_stats[:losses] += 1
    winner_stats[:goals_for] += wo_score
    loser_stats[:goals_against] += wo_score
    winner_stats[:points] += scoring_data["win"].to_i
    loser_stats[:points] += scoring_data["wo"].to_i

    finalize_standing_totals!(winner_stats)
    finalize_standing_totals!(loser_stats)
  end

  def apply_match_points!(winner_stats, loser_stats, win_points, loss_points)
    winner_stats[:wins] += 1
    loser_stats[:losses] += 1
    winner_stats[:points] += win_points.to_i
    loser_stats[:points] += loss_points.to_i
  end

  def knockout_match_source_id(category, index)
    "knockout-#{id}-#{category.id}-r1-#{index}"
  end

  def knockout_match_code(category, index)
    [category.name.parameterize.upcase.presence || "CAT", "R1", index].join("-")
  end

  def finalize_standing_totals!(stats)
    stats[:goal_diff] = stats[:goals_for] - stats[:goals_against]
  end

  def assign_slug
    return if slug.present?
    return if name.blank? || season.blank?

    base_slug = [name, season].join(" ").parameterize
    self.slug = base_slug

    if self.class.where.not(id: id).exists?(slug: slug)
      self.slug = "#{base_slug}-#{source_id.presence || SecureRandom.hex(4)}".parameterize
    end
  end
end
