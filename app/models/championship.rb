class Championship < ApplicationRecord
  ScorerEntry = Struct.new(:athlete_id, :name, :team_name, :goals, keyword_init: true)
  StandingGroup = Struct.new(:category, :group_key, :rows, keyword_init: true)

  MODALITIES = {
    football: "football",
    tranca: "tranca"
  }.freeze

  MODALITY_LABELS = {
    "football" => "Futebol",
    "tranca" => "Tranca"
  }.freeze

  COMPETITION_MODES = {
    "pontuacao" => "Pontuação por chaves",
    "mata_mata" => "Mata-mata eliminatório",
    "grupos_mata_mata" => "Fase de grupos + mata-mata"
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
  has_one :tranca_setting, class_name: "Tranca::Setting", dependent: :destroy
  has_many :tranca_duplas, class_name: "Tranca::Dupla", dependent: :destroy
  has_many :tranca_rodadas, class_name: "Tranca::Rodada", dependent: :destroy
  has_many :tranca_mesas, class_name: "Tranca::Mesa", dependent: :destroy
  has_many :tranca_partidas, class_name: "Tranca::Partida", dependent: :destroy
  has_many :tranca_partida_maos, class_name: "Tranca::PartidaMao", dependent: :destroy
  has_many :tranca_classificacao_rows, class_name: "Tranca::ClassificacaoRow", dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :venues, dependent: :nullify
  has_many :referees, dependent: :nullify
  has_many :partners, dependent: :destroy
  has_many :championship_memberships, dependent: :destroy
  has_many :users, through: :championship_memberships
  has_many :match_events, dependent: :destroy
  has_many :match_reports, through: :matches
  has_many :suspensions, dependent: :destroy
  has_one_attached :logo

  enum :modality, MODALITIES, default: :football
  enum :status, {
    rascunho: "rascunho",
    inscricoes_abertas: "inscricoes_abertas",
    em_andamento: "em_andamento",
    finalizado: "finalizado"
  }, default: :rascunho

  validates :source_id, :name, :season, presence: true
  validates :source_id, uniqueness: true
  validates :slug, uniqueness: true, allow_blank: true
  validates :modality, inclusion: { in: modalities.keys }
  before_validation :assign_source_id, on: :create
  before_validation :assign_slug, on: :create

  scope :publicly_visible, -> { where.not(status: :rascunho) }
  scope :for_modality, ->(modality) { where(modality: modality) }

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

  def modality_label
    MODALITY_LABELS[modality] || modality.to_s.humanize
  end

  def portal_menu_for(modality = self.modality)
    case modality.to_s
    when "tranca"
      [
        "Início",
        "Campeonato",
        "Partidas",
        "Duplas",
        "Estatísticas",
        "Regulamento"
      ]
    else
      [
        "Início",
        "Campeonato",
        "Jogos",
        "Equipes",
        "Classificação"
      ]
    end
  end

  def self.modality_options
    MODALITIES.keys.map { |key| [MODALITY_LABELS.fetch(key.to_s), key] }
  end

  def points_based_mode?
    format_data["mode"].to_s == "pontuacao"
  end

  def knockout_only_mode?
    format_data["mode"].to_s == "mata_mata"
  end

  def group_stage_and_knockout_mode?
    format_data["mode"].to_s == "grupos_mata_mata"
  end

  def matches_per_opponent
    value = format_data.fetch("matchesPerOpponent", default_format.fetch("matchesPerOpponent")).to_i
    value.positive? ? value : 1
  end

  def matches_per_opponent_label
    return "Sem jogos por confronto" if knockout_only_mode?

    "#{matches_per_opponent} #{'vez'.pluralize(matches_per_opponent)} por adversário"
  end

  def qualified_per_group
    group_stage_and_knockout_mode? ? format_data.fetch("qualifiedPerGroup", default_scoring.fetch("qualifiedPerGroup")).to_i.clamp(1, 16) : 0
  end

  def group_count
    value = format_data.fetch("groupCount", default_format.fetch("groupCount")).to_i
    value.positive? ? value : 1
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

  def record_public_signup_visit!
    self.class.increment_counter(:public_signup_visits_count, id)
  end

  def public_signup_visits_total
    public_signup_visits_count.to_i
  end

  def tranca_onboarding_category_source_id
    "category-tranca-#{source_id}"
  end

  def ensure_tranca_onboarding_category!
    return unless tranca?

    category = categories.find_by(source_id: tranca_onboarding_category_source_id) || Category.find_or_initialize_by(source_id: tranca_onboarding_category_source_id)
    category.assign_attributes(
      championship: self,
      name: name
    )
    category.save!
    category
  end

  def recent_tranca_championships(limit: 3)
    Championship.tranca.where.not(id: id).order(season: :desc, created_at: :desc).limit(limit).includes(categories: { teams: :athletes })
  end

  def invite_selected_tranca_duplas!(teams)
    return 0 unless tranca?

    category = ensure_tranca_onboarding_category!
    invited = 0

    Array(teams).each do |team|
      next if team.blank?
      next if tranca_dupla_already_invited?(category, team)

      duplicate_team_into_category!(team, category)
      invited += 1
    end

    invited
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
      "groupCount" => [categories.size, 1].max,
      "qualifiedPerGroup" => default_scoring.fetch("qualifiedPerGroup"),
      "matchesPerOpponent" => 1
    }
  end

  def completed_matches
    matches.includes(:team_a, :team_b, :winner, :category).where(status: %w[finalizado wo]).order(scheduled_on: :desc, id: :desc)
  end

  def recent_matches(limit = 8)
    matches.includes(:team_a, :team_b, :winner, :category).order(scheduled_on: :desc, id: :desc).limit(limit)
  end

  def standing_groups
    standing_rows.includes(:team, :category)
      .order(:category_id, :group_key, :position, points: :desc, goal_diff: :desc, goals_for: :desc)
      .group_by { |row| [row.category, row.group_key.to_s] }
      .map { |(category, group_key), rows| StandingGroup.new(category: category, group_key: group_key, rows: rows) }
      .sort_by { |group| [group.category.name.to_s.downcase, group.group_key.to_s.downcase] }
  end

  def standings_by_category
    standing_groups.group_by(&:category)
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
      standings_groups_for(category).each do |group_key, matches|
        completed_matches = matches.select { |match| match.status_finalizado? || match.status_wo? }
        team_ids = matches.flat_map { |match| [match.team_a_id, match.team_b_id] }.compact.uniq
        teams_by_id = if group_key.present? && team_ids.any?
          Team.includes(:entity).where(id: team_ids).index_by(&:id)
        else
          participating_teams_for(category).index_by(&:id)
        end
        team_stats = teams_by_id.transform_values { |team| standing_stats_for(team, group_key) }

        completed_matches.each do |match|
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
            group_key: group_key,
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
            qualified: group_stage_and_knockout_mode? ? index < qualified_per_group : nil
          )
        end
      end
    end

    transaction do
      standing_rows.delete_all
      rebuilt_rows.each(&:save!)
      sync_tranca_classificacao_rows_from_legacy! if tranca?
    end
  end

  def advance_group_stage_knockout_from!(match)
    return unless group_stage_and_knockout_mode?
    return unless match.classification_phase?
    return unless match.status_finalizado? || match.status_wo?
    return unless group_stage_complete_for?(match.category)
    return if matches.where(category_id: match.category_id, phase: "mata_mata", round_number: 1).exists?

    draw_group_stage_knockout_round_for!(match.category)
  end

  def advance_knockout_from!(match)
    return unless match.knockout_phase?

    sync_knockout_brackets!
  end

  def sync_knockout_brackets!
    knockout_matches = matches
      .includes(:team_a, :team_b, :winner)
      .where(phase: "mata_mata")
      .order(:category_id, :round_number, :id)
      .to_a

    knockout_matches.group_by(&:category_id).each_value do |category_matches|
      sync_knockout_category_matches!(category_matches)
    end
  end

  def draw_initial_knockout_round!
    raise ArgumentError, "campeonato precisa estar em mata-mata" unless format_data["mode"].to_s == "mata_mata"

    created_matches = []

    transaction do
      categories.includes(:teams).find_each do |category|
        next if matches.where(category_id: category.id, phase: "mata_mata", round_number: 1).exists?

        shuffled_teams = participating_teams_for(category).shuffle
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

  def finalize_registrations!
    transaction do
      disable_team_signups!

      created_matches =
        if knockout_only_mode?
          draw_initial_knockout_round!
        else
          draw_initial_group_stage_round!
        end

      update!(status: :em_andamento) unless finalizado?
      rebuild_standings! unless knockout_only_mode?
      created_matches
    end
  end

  def draw_initial_group_stage_round!
    raise ArgumentError, "campeonato precisa estar em pontuação ou grupos + mata-mata" if knockout_only_mode?

    created_matches = []

    transaction do
      categories.includes(:teams).find_each do |category|
        next if classification_matches_for(category).any?

        participating_teams = participating_teams_for(category)
        next if participating_teams.size < 2

        initial_group_assignments_for(participating_teams).each do |group_key, group_teams|
          next if group_teams.size < 2

          pairings = group_teams.combination(2).to_a.sort_by do |team_a, team_b|
            [team_a.name.to_s.downcase, team_b.name.to_s.downcase]
          end

          pairings.each_with_index do |(team_a, team_b), pair_index|
            matches_per_opponent.times do |repetition_index|
              repetition = repetition_index + 1
              created_matches << matches.create!(
                source_id: classification_match_source_id(category, group_key, team_a, team_b, repetition),
                category: category,
                code: classification_match_code(category, group_key, team_a, team_b, repetition),
                phase: "grupos",
                group_key: group_key,
                round_number: pair_index + 1,
                team_a: team_a,
                team_b: team_b,
                status: :agendado
              )
            end
          end
        end
      end
    end

    created_matches
  end

  def draw_group_stage_knockout_round_for!(category)
    raise ArgumentError, "campeonato precisa estar em grupos + mata-mata" unless group_stage_and_knockout_mode?
    return [] unless group_stage_complete_for?(category)
    return [] if matches.where(category_id: category.id, phase: "mata_mata", round_number: 1).exists?

    created_matches = []

    transaction do
      group_standings = standing_groups.select { |group| group.category == category }
      next if group_standings.size < 2

      group_standings.each_slice(2) do |left_group, right_group|
        next if right_group.blank?

        pair_count = [qualified_per_group, left_group.rows.size, right_group.rows.size].min
        pair_count.times do |index|
          left_row = left_group.rows[index]
          right_row = right_group.rows[pair_count - 1 - index]
          next if left_row.blank? || right_row.blank?

          created_matches << matches.create!(
            source_id: knockout_group_match_source_id(category, left_group.group_key, right_group.group_key, index + 1),
            category: category,
            code: knockout_group_match_code(category, left_group.group_key, right_group.group_key, index + 1),
            phase: "mata_mata",
            round_number: 1,
            team_a: left_row.team,
            team_b: right_row.team,
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

  def standing_stats_for(team, group_key = "")
    {
      team: team,
      group_key: group_key.to_s,
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
      .select(&:classification_phase?)
      .sort_by { |match| [match.scheduled_on || Date.new(1900, 1, 1), match.id] }
  end

  def completed_classification_matches_for(category)
    classification_matches_for(category).select { |match| match.status_finalizado? || match.status_wo? }
  end

  def standings_groups_for(category)
    grouped_matches = classification_matches_for(category)
      .group_by { |match| match.group_key.to_s }
    grouped_matches = { "" => [] } if grouped_matches.empty?

    grouped_matches.sort_by { |group_key, _matches| group_key.to_s }
  end

  def group_stage_complete_for?(category)
    classification_matches = classification_matches_for(category)
    return false if classification_matches.blank?
    return false unless classification_matches.all? { |match| match.status_finalizado? || match.status_wo? }

    classification_team_ids = classification_matches.flat_map { |match| [match.team_a_id, match.team_b_id] }.compact.uniq.sort
    category_team_ids = participating_teams_for(category).map(&:id).sort

    classification_team_ids == category_team_ids
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

  def sync_knockout_category_matches!(category_matches)
    rounds = category_matches
      .select(&:knockout_phase?)
      .group_by(&:round_number)
      .sort_by { |round_number, _| round_number.to_i }

    return if rounds.size < 2

    previous_winners = rounds.first.last.sort_by(&:id).map do |match|
      knockout_winner = match.knockout_winner
      next knockout_winner if knockout_winner.blank?

      if (match.status_finalizado? || match.status_wo?) && match.winner_id.blank?
        match.update_columns(winner_id: knockout_winner.id, updated_at: Time.current)
      end

      knockout_winner
    end.compact

    rounds.drop(1).each do |_round_number, round_matches|
      expected_pairs = previous_winners.each_slice(2).to_a

      round_matches.sort_by(&:id).each_with_index do |round_match, index|
        next if round_match.status_finalizado? || round_match.status_wo?

        expected_team_a, expected_team_b = expected_pairs[index] || [nil, nil]
        next if round_match.team_a_id == expected_team_a&.id && round_match.team_b_id == expected_team_b&.id

        round_match.update_columns(
          team_a_id: expected_team_a&.id,
          team_b_id: expected_team_b&.id,
          updated_at: Time.current
        )
      end

      previous_winners = round_matches.sort_by(&:id).map do |match|
        knockout_winner = match.knockout_winner
        next knockout_winner if knockout_winner.blank?

        if (match.status_finalizado? || match.status_wo?) && match.winner_id.blank?
          match.update_columns(winner_id: knockout_winner.id, updated_at: Time.current)
        end

        knockout_winner
      end.compact
    end
  end

  def knockout_match_source_id(category, index)
    "knockout-#{id}-#{category.id}-r1-#{index}"
  end

  def knockout_group_match_source_id(category, left_group_key, right_group_key, index)
    "knockout-#{id}-#{category.id}-#{left_group_key.presence || 'general'}-#{right_group_key.presence || 'general'}-r1-#{index}"
  end

  def knockout_match_code(category, index)
    [category.name.parameterize.upcase.presence || "CAT", "R1", index].join("-")
  end

  def knockout_group_match_code(category, left_group_key, right_group_key, index)
    [
      category.name.parameterize.upcase.presence || "CAT",
      left_group_key.presence || "G",
      right_group_key.presence || "G",
      "R1",
      index
    ].join("-")
  end

  def finalize_standing_totals!(stats)
    stats[:goal_diff] = stats[:goals_for] - stats[:goals_against]
  end

  def participating_teams_for(category)
    approved_teams = category.teams.select(&:registration_status_aprovada?)
    approved_teams.presence || category.teams.to_a
  end

  def initial_group_assignments_for(teams)
    teams = Array(teams).sort_by { |team| team.name.to_s.downcase }

    if teams.any? { |team| team.group_key.present? }
      teams.group_by { |team| team.group_key.to_s.presence || "Geral" }.sort_by { |group_key, _| group_key.to_s.downcase }.to_h
    else
      buckets = Array.new(group_count) { [] }

      teams.each_with_index do |team, index|
        buckets[index % group_count] << team
      end

      buckets.each_with_index.each_with_object({}) do |(group_teams, index), hash|
        next if group_teams.blank?

        hash[group_label_for(index)] = group_teams
      end
    end
  end

  def group_label_for(index)
    number = index.to_i + 1
    label = +""

    while number.positive?
      number, remainder = (number - 1).divmod(26)
      label.prepend((65 + remainder).chr)
    end

    label
  end

  def classification_match_source_id(category, group_key, team_a, team_b, repetition)
    "classification-#{id}-#{category.id}-#{group_key.presence || 'general'}-#{team_a.id}-#{team_b.id}-#{repetition}"
  end

  def classification_match_code(category, group_key, team_a, team_b, repetition)
    [
      category.name.parameterize.upcase.presence || "CAT",
      group_key.presence || "G",
      team_a.name.parameterize.upcase.presence || "A",
      team_b.name.parameterize.upcase.presence || "B",
      "R#{repetition}"
    ].join("-")
  end

  def disable_team_signups!
    updated_rules = (rules.presence || {}).deep_dup
    updated_rules["registration"] ||= {}
    updated_rules["registration"]["team_signups"] ||= {}
    updated_rules["registration"]["team_signups"]["enabled"] = false
    updated_rules["registration"]["team_signups"]["status"] = "inscricoes_fechadas"
    update!(rules: updated_rules)
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

  def assign_source_id
    self.source_id ||= "championship-#{SecureRandom.hex(4)}"
  end

  def sync_tranca_classificacao_rows_from_legacy!
    tranca_classificacao_rows.delete_all

    standing_rows.includes(:team, :category).order(:category_id, :group_key, position: :asc, points: :desc, goal_diff: :desc).find_each do |row|
      tranca_dupla = Tranca::Dupla.find_by(source_id: row.team.source_id)
      next if tranca_dupla.blank?

      tranca_classificacao_rows.create!(
        category: row.category,
        tranca_dupla: tranca_dupla,
        source_id: "tranca-standing-row-#{row.id}",
        group_key: row.group_key,
        position: row.position,
        played: row.played,
        wins: row.wins,
        draws: row.draws,
        losses: row.losses,
        goals_for: row.goals_for,
        goals_against: row.goals_against,
        goal_diff: row.goal_diff,
        points: row.points,
        qualified: row.qualified
      )
    end
  end

  private

  def duplicate_team_into_category!(team, category)
    duplicated_team = Team.find_or_initialize_by(source_id: invite_team_source_id(team, category))
    duplicated_team.category = category
    duplicated_team.entity = team.entity
    duplicated_team.name = team.name
    duplicated_team.short_name = team.short_name
    duplicated_team.registration_status = :pendente
    duplicated_team.finance_status = :pendente
    duplicated_team.save!

    team.athletes.find_each do |athlete|
      duplicated_athlete = duplicated_team.team_athletes.find_or_initialize_by(source_id: invite_team_athlete_source_id(team, athlete))
      duplicated_athlete.athlete = athlete
      duplicated_athlete.save!
    end

    duplicated_team
  end

  def tranca_dupla_already_invited?(category, team)
    category.teams.exists?(source_id: invite_team_source_id(team, category)) ||
      category.teams.exists?(name: team.name, entity_id: team.entity_id)
  end

  def invite_team_source_id(team, category)
    "tranca-invite-#{id}-#{category.id}-#{team.id}"
  end

  def invite_team_athlete_source_id(team, athlete)
    "tranca-invite-member-#{id}-#{team.id}-#{athlete.id}"
  end

end
