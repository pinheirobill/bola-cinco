require "json"

users = [
  { email: "admin@bola-cinco.local", role: :adm_master },
  { email: "quadra@bola-cinco.local", role: :dono_da_quadra },
  { email: "tecnico@bola-cinco.local", role: :tecnico_do_time },
  { email: "jogador@bola-cinco.local", role: :jogador_do_time }
]

users.each do |attrs|
  user = User.find_or_initialize_by(email: attrs.fetch(:email))
  user.role = attrs.fetch(:role)
  user.password = "password123"
  user.password_confirmation = "password123"
  user.save!
end

def import_championship_snapshot!(path)
  snapshot = JSON.parse(File.read(path))
  championship = BolaCinco::Importer.new(path: path.to_s).call

  championship.update!(
    status: snapshot.fetch("championship").fetch("status"),
    modality: snapshot.fetch("championship").fetch("modality", championship.modality),
    notes: snapshot["notes"],
    rules: championship.default_rules.deep_merge(snapshot["rules"] || {}),
    format: championship.default_format.merge(snapshot["format"] || {}),
    scoring: championship.default_scoring.merge(snapshot["scoring"] || {})
  )

  apply_bootstrap_competition_format!(championship)

  championship
end

def apply_bootstrap_competition_format!(championship)
  return unless championship.tranca?

  classification_matches = championship.matches.where(phase: "classificatoria")
  knockout_matches = championship.matches.where(phase: "mata_mata")
  return if classification_matches.blank? || knockout_matches.blank?

  group_keys = classification_matches.where.not(group_key: [ nil, "" ]).distinct.pluck(:group_key).sort
  group_count = group_keys.size
  knockout_round_1_count = knockout_matches.where(round_number: 1).count
  qualified_per_group = if group_count.positive? && knockout_round_1_count.positive?
    [ knockout_round_1_count / group_count, 1 ].max
  else
    championship.default_format.fetch("qualifiedPerGroup", 2)
  end

  championship.update!(
    format: championship.default_format.merge(
      "mode" => "grupos_mata_mata",
      "teamCount" => championship.teams.count,
      "groupCount" => group_count.positive? ? group_count : championship.default_format.fetch("groupCount", 1),
      "qualifiedPerGroup" => qualified_per_group,
      "matchesPerOpponent" => 1
    )
  )
end

def bootstrap_tranca_domain!(championship)
  return unless championship.tranca?

  championship.tranca_setting&.destroy!
  championship.create_tranca_setting!(
    source_id: "tranca-setting-#{championship.id}",
    rules: championship.rules.presence || {},
    scoring: championship.scoring.presence || {},
    format: championship.format.presence || {}
  )

  championship.teams.includes(:entity, :category, :athletes).find_each do |team|
    dupla = Tranca::Dupla.find_or_initialize_by(source_id: team.source_id)
    dupla.update!(
      championship: championship,
      category: team.category,
      entity: team.entity,
      name: team.name,
      short_name: team.short_name,
      registration_status: team.registration_status
    )

    team.athletes.each_with_index do |athlete, index|
      membership = Tranca::DuplaMembership.find_or_initialize_by(
        source_id: "tranca-dupla-membership-#{championship.id}-#{team.id}-#{athlete.id}"
      )
      membership.update!(
        tranca_dupla: dupla,
        athlete: athlete,
        position: index + 1,
        shirt_number: athlete.shirt_number
      )
    end
  end

  championship.matches.includes(:category, :team_a, :team_b, :winner).order(:scheduled_on, :scheduled_time, :id).each do |match|
    rodada = Tranca::Rodada.find_or_initialize_by(
      source_id: tranca_round_source_id(championship, match.phase, match.round_number)
    )
    rodada.update!(
      championship: championship,
      phase: match.phase,
      round_number: match.round_number,
      label: tranca_round_label(match.phase, match.round_number),
      status: "programada"
    )

    mesa = Tranca::Mesa.find_or_initialize_by(source_id: tranca_mesa_source_id(match))
    mesa.update!(
      championship: championship,
      tranca_rodada: rodada,
      code: [ match.group_key.presence || "G", match.code ].compact.join("-"),
      name: match.venue.presence || "Mesa #{match.code}",
      location: match.venue,
      status: tranca_mesa_status_for(match.status)
    )

    partida = Tranca::Partida.find_or_initialize_by(source_id: match.source_id)
    partida.update!(
      championship: championship,
      category: match.category,
      tranca_rodada: rodada,
      tranca_mesa: mesa,
      dupla_a: championship.tranca_duplas.find_by(source_id: match.team_a&.source_id),
      dupla_b: championship.tranca_duplas.find_by(source_id: match.team_b&.source_id),
      winner: championship.tranca_duplas.find_by(source_id: match.winner&.source_id),
      code: match.code,
      phase: match.phase,
      round_number: match.round_number,
      group_key: match.group_key.to_s,
      scheduled_on: match.scheduled_on,
      scheduled_time: match.scheduled_time,
      score_a: match.score_a,
      score_b: match.score_b,
      status: match.status,
      decision: match.decision,
      penalties_a: match.penalties_a,
      penalties_b: match.penalties_b,
      wo: match.wo,
      source_data: match.source_data
    )
  end

  Tranca::CompetitionFlow.new(championship).rebuild_classificacao!
end

def tranca_phase_label(phase)
  case phase.to_s
  when "classificatoria" then "Classificatória"
  when "mata_mata" then "Mata-mata"
  else phase.to_s.tr("_", " ").humanize
  end
end

def tranca_round_source_id(championship, phase, round_number)
  "tranca-round-#{championship.id}-#{phase}-#{round_number}"
end

def tranca_round_label(phase, round_number)
  "Rodada #{round_number} · #{tranca_phase_label(phase)}"
end

def tranca_mesa_source_id(match)
  "tranca-mesa-#{match.source_id}"
end

def tranca_mesa_status_for(status)
  case status.to_s
  when "finalizado", "wo" then "ocupada"
  when "em_andamento" then "em_uso"
  else "disponivel"
  end
end

if ENV["BOLA_CINCO_BOOTSTRAP_CHAMPIONSHIPS"] == "1"
  import_championship_snapshot!(Rails.root.join("db/seeds/bola_cinco_import_2026.json"))
  import_championship_snapshot!(Rails.root.join("db/seeds/chis_cup_2026.json"))
  bootstrap_tranca_domain!(import_championship_snapshot!(Rails.root.join("db/seeds/tranca_2026.json")))

  load Rails.root.join("db/seeds/arbitros_e_campos.rb") if Rails.root.join("db/seeds/arbitros_e_campos.rb").exist?
  load Rails.root.join("db/seeds/demo_athletes_and_goals.rb") if Rails.root.join("db/seeds/demo_athletes_and_goals.rb").exist?
end
