class CreateTrancaDomain < ActiveRecord::Migration[8.1]
  def up
    create_table :tranca_settings do |t|
      t.references :championship, null: false, foreign_key: true, index: false
      t.string :source_id, null: false
      t.json :rules, null: false, default: {}
      t.json :scoring, null: false, default: {}
      t.json :format, null: false, default: {}
      t.timestamps
    end

    add_index :tranca_settings, :source_id, unique: true
    add_index :tranca_settings, :championship_id, unique: true

    create_table :tranca_duplas do |t|
      t.references :championship, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :entity, foreign_key: true
      t.string :source_id, null: false
      t.string :name, null: false
      t.string :short_name
      t.string :registration_status, null: false, default: "aprovada"
      t.timestamps
    end

    add_index :tranca_duplas, :source_id, unique: true
    add_index :tranca_duplas, %i[championship_id category_id name], unique: true, name: "index_tranca_duplas_on_scope_and_name"

    create_table :tranca_dupla_memberships do |t|
      t.references :tranca_dupla, null: false, foreign_key: true
      t.references :athlete, null: false, foreign_key: true
      t.string :source_id, null: false
      t.integer :position
      t.string :shirt_number
      t.timestamps
    end

    add_index :tranca_dupla_memberships, :source_id, unique: true
    add_index :tranca_dupla_memberships, %i[tranca_dupla_id athlete_id], unique: true, name: "index_tranca_dupla_memberships_on_dupla_and_athlete"

    create_table :tranca_rodadas do |t|
      t.references :championship, null: false, foreign_key: true
      t.string :source_id, null: false
      t.string :phase, null: false
      t.integer :round_number, null: false
      t.string :label, null: false
      t.string :status, null: false, default: "programada"
      t.date :starts_on
      t.date :ends_on
      t.timestamps
    end

    add_index :tranca_rodadas, :source_id, unique: true
    add_index :tranca_rodadas, %i[championship_id phase round_number], unique: true, name: "index_tranca_rodadas_on_scope_and_round"

    create_table :tranca_mesas do |t|
      t.references :championship, null: false, foreign_key: true
      t.references :tranca_rodada, foreign_key: true
      t.string :source_id, null: false
      t.string :code, null: false
      t.string :name, null: false
      t.string :location
      t.string :status, null: false, default: "disponivel"
      t.timestamps
    end

    add_index :tranca_mesas, :source_id, unique: true
    add_index :tranca_mesas, %i[championship_id code], unique: true, name: "index_tranca_mesas_on_scope_and_code"

    create_table :tranca_partidas do |t|
      t.references :championship, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :tranca_rodada, foreign_key: true
      t.references :tranca_mesa, foreign_key: true
      t.references :dupla_a, foreign_key: { to_table: :tranca_duplas }
      t.references :dupla_b, foreign_key: { to_table: :tranca_duplas }
      t.references :winner, foreign_key: { to_table: :tranca_duplas }
      t.string :source_id, null: false
      t.string :code, null: false
      t.string :phase, null: false
      t.integer :round_number
      t.string :group_key
      t.date :scheduled_on
      t.string :scheduled_time
      t.string :status, null: false, default: "agendado"
      t.integer :score_a
      t.integer :score_b
      t.string :decision
      t.integer :penalties_a
      t.integer :penalties_b
      t.string :wo
      t.json :source_data, null: false, default: {}
      t.timestamps
    end

    add_index :tranca_partidas, :source_id, unique: true
    add_index :tranca_partidas, %i[championship_id scheduled_on], name: "index_tranca_partidas_on_championship_and_date"
    add_index :tranca_partidas, %i[championship_id phase round_number], name: "index_tranca_partidas_on_scope_phase_round"

    create_table :tranca_classificacao_rows do |t|
      t.references :championship, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :tranca_dupla, null: false, foreign_key: true
      t.string :source_id, null: false
      t.string :group_key, null: false, default: ""
      t.integer :position, null: false
      t.integer :played, null: false, default: 0
      t.integer :wins, null: false, default: 0
      t.integer :draws, null: false, default: 0
      t.integer :losses, null: false, default: 0
      t.integer :goals_for, null: false, default: 0
      t.integer :goals_against, null: false, default: 0
      t.integer :goal_diff, null: false, default: 0
      t.integer :points, null: false, default: 0
      t.boolean :qualified
      t.timestamps
    end

    add_index :tranca_classificacao_rows, :source_id, unique: true
    add_index :tranca_classificacao_rows, %i[championship_id category_id group_key position], unique: true, name: "index_tranca_classificacao_rows_on_scope_and_position"
    add_index :tranca_classificacao_rows, %i[category_id group_key tranca_dupla_id], unique: true, name: "index_tranca_classificacao_rows_on_group_and_dupla"

    backfill_legacy_tranca_data
  end

  def down
    drop_table :tranca_classificacao_rows if table_exists?(:tranca_classificacao_rows)
    drop_table :tranca_partidas if table_exists?(:tranca_partidas)
    drop_table :tranca_mesas if table_exists?(:tranca_mesas)
    drop_table :tranca_rodadas if table_exists?(:tranca_rodadas)
    drop_table :tranca_dupla_memberships if table_exists?(:tranca_dupla_memberships)
    drop_table :tranca_duplas if table_exists?(:tranca_duplas)
    drop_table :tranca_settings if table_exists?(:tranca_settings)
  end

  private

  def backfill_legacy_tranca_data
    championship_ids = select_values("SELECT id FROM championships WHERE modality = 'tranca'")

    championship_ids.each do |championship_id|
      backfill_tranca_setting(championship_id)
      backfill_tranca_duplas(championship_id)
      backfill_tranca_dupla_memberships(championship_id)
      backfill_tranca_rodadas(championship_id)
      backfill_tranca_mesas(championship_id)
      backfill_tranca_partidas(championship_id)
      backfill_tranca_classificacao_rows(championship_id)
    end
  end

  def backfill_tranca_setting(championship_id)
    championship = select_all("SELECT id, source_id, rules, scoring, format, created_at, updated_at FROM championships WHERE id = #{quote(championship_id)}").first
    return if championship.blank?

    insert_row(:tranca_settings, {
      championship_id: championship["id"],
      source_id: "tranca-setting-#{championship["id"]}",
      rules: championship["rules"],
      scoring: championship["scoring"],
      format: championship["format"],
      created_at: championship["created_at"],
      updated_at: championship["updated_at"]
    })
  end

  def backfill_tranca_duplas(championship_id)
    team_rows = select_all(<<~SQL)
      SELECT teams.*
      FROM teams
      INNER JOIN categories ON categories.id = teams.category_id
      WHERE categories.championship_id = #{quote(championship_id)}
    SQL

    team_rows.each do |team|
      insert_row(:tranca_duplas, {
        championship_id: championship_id,
        category_id: team["category_id"],
        entity_id: team["entity_id"],
        source_id: team["source_id"],
        name: team["name"],
        short_name: team["short_name"],
        registration_status: team["registration_status"],
        created_at: team["created_at"],
        updated_at: team["updated_at"]
      })
    end
  end

  def backfill_tranca_dupla_memberships(championship_id)
    dupla_id_by_team_id = build_dupla_id_by_team_id(championship_id)
    memberships = select_all(<<~SQL)
      SELECT team_athletes.*
      FROM team_athletes
      INNER JOIN teams ON teams.id = team_athletes.team_id
      INNER JOIN categories ON categories.id = teams.category_id
      WHERE categories.championship_id = #{quote(championship_id)}
    SQL

    memberships.each do |membership|
      tranca_dupla_id = dupla_id_by_team_id[membership["team_id"]]
      next if tranca_dupla_id.blank?

      insert_row(:tranca_dupla_memberships, {
        tranca_dupla_id: tranca_dupla_id,
        athlete_id: membership["athlete_id"],
        source_id: membership["source_id"],
        position: membership["position"],
        shirt_number: membership["shirt_number"],
        created_at: membership["created_at"],
        updated_at: membership["updated_at"]
      })
    end
  end

  def backfill_tranca_rodadas(championship_id)
    round_rows = select_all(<<~SQL)
      SELECT DISTINCT phase, round_number
      FROM matches
      WHERE championship_id = #{quote(championship_id)}
      ORDER BY phase, round_number
    SQL

    round_rows.each do |round|
      phase = round["phase"].to_s
      round_number = round["round_number"].to_i

      insert_row(:tranca_rodadas, {
        championship_id: championship_id,
        source_id: tranca_round_source_id(championship_id, phase, round_number),
        phase: phase,
        round_number: round_number,
        label: tranca_round_label(phase, round_number),
        status: "programada",
        created_at: Time.current,
        updated_at: Time.current
      })
    end
  end

  def backfill_tranca_mesas(championship_id)
    match_rows = select_all(<<~SQL)
      SELECT *
      FROM matches
      WHERE championship_id = #{quote(championship_id)}
      ORDER BY scheduled_on, scheduled_time, id
    SQL

    match_rows.each do |match|
      insert_row(:tranca_mesas, {
        championship_id: championship_id,
        tranca_rodada_id: tranca_rodada_id_for(championship_id, match["phase"], match["round_number"]),
        source_id: tranca_mesa_source_id(match["id"]),
        code: match["code"],
        name: match["venue"].presence || "Mesa #{match["code"]}",
        location: match["venue"],
        status: tranca_mesa_status_for(match["status"]),
        created_at: match["created_at"],
        updated_at: match["updated_at"]
      })
    end
  end

  def backfill_tranca_partidas(championship_id)
    dupla_id_by_team_id = build_dupla_id_by_team_id(championship_id)
    mesa_id_by_match_id = build_mesa_id_by_match_id(championship_id)

    match_rows = select_all(<<~SQL)
      SELECT *
      FROM matches
      WHERE championship_id = #{quote(championship_id)}
      ORDER BY scheduled_on, scheduled_time, id
    SQL

    match_rows.each do |match|
      insert_row(:tranca_partidas, {
        championship_id: championship_id,
        category_id: match["category_id"],
        tranca_rodada_id: tranca_rodada_id_for(championship_id, match["phase"], match["round_number"]),
        tranca_mesa_id: mesa_id_by_match_id[match["id"]],
        dupla_a_id: dupla_id_by_team_id[match["team_a_id"]],
        dupla_b_id: dupla_id_by_team_id[match["team_b_id"]],
        winner_id: dupla_id_by_team_id[match["winner_id"]],
        source_id: match["source_id"],
        code: match["code"],
        phase: match["phase"],
        round_number: match["round_number"],
        group_key: match["group_key"].to_s,
        scheduled_on: match["scheduled_on"],
        scheduled_time: match["scheduled_time"],
        status: match["status"],
        score_a: match["score_a"],
        score_b: match["score_b"],
        decision: match["decision"],
        penalties_a: match["penalties_a"],
        penalties_b: match["penalties_b"],
        wo: match["wo"],
        source_data: match["source_data"],
        created_at: match["created_at"],
        updated_at: match["updated_at"]
      })
    end
  end

  def backfill_tranca_classificacao_rows(championship_id)
    dupla_id_by_team_id = build_dupla_id_by_team_id(championship_id)
    standing_rows = select_all(<<~SQL)
      SELECT *
      FROM standing_rows
      WHERE championship_id = #{quote(championship_id)}
      ORDER BY category_id, group_key, position
    SQL

    standing_rows.each do |row|
      tranca_dupla_id = dupla_id_by_team_id[row["team_id"]]
      next if tranca_dupla_id.blank?

      insert_row(:tranca_classificacao_rows, {
        championship_id: championship_id,
        category_id: row["category_id"],
        tranca_dupla_id: tranca_dupla_id,
        source_id: "tranca-classificacao-#{row["id"]}",
        group_key: row["group_key"],
        position: row["position"],
        played: row["played"],
        wins: row["wins"],
        draws: row["draws"],
        losses: row["losses"],
        goals_for: row["goals_for"],
        goals_against: row["goals_against"],
        goal_diff: row["goal_diff"],
        points: row["points"],
        qualified: row["qualified"],
        created_at: row["created_at"],
        updated_at: row["updated_at"]
      })
    end
  end

  def build_dupla_id_by_team_id(championship_id)
    team_rows = select_all(<<~SQL)
      SELECT teams.id, teams.source_id
      FROM teams
      INNER JOIN categories ON categories.id = teams.category_id
      WHERE categories.championship_id = #{quote(championship_id)}
    SQL

    dupla_rows = select_all(<<~SQL)
      SELECT id, source_id
      FROM tranca_duplas
      WHERE championship_id = #{quote(championship_id)}
    SQL

    dupla_id_by_source_id = dupla_rows.each_with_object({}) do |row, hash|
      hash[row["source_id"]] = row["id"]
    end

    team_rows.each_with_object({}) do |row, hash|
      hash[row["id"]] = dupla_id_by_source_id[row["source_id"]]
    end
  end

  def build_mesa_id_by_match_id(championship_id)
    match_rows = select_all(<<~SQL)
      SELECT id
      FROM matches
      WHERE championship_id = #{quote(championship_id)}
    SQL

    mesa_rows = select_all(<<~SQL)
      SELECT id, source_id
      FROM tranca_mesas
      WHERE championship_id = #{quote(championship_id)}
    SQL

    mesa_id_by_source_id = mesa_rows.each_with_object({}) do |row, hash|
      hash[row["source_id"]] = row["id"]
    end

    match_rows.each_with_object({}) do |row, hash|
      hash[row["id"]] = mesa_id_by_source_id[tranca_mesa_source_id(row["id"])]
    end
  end

  def tranca_rodada_id_for(championship_id, phase, round_number)
    select_value(<<~SQL)
      SELECT id
      FROM tranca_rodadas
      WHERE championship_id = #{quote(championship_id)}
        AND phase = #{quote(phase.to_s)}
        AND round_number = #{quote(round_number.to_i)}
    SQL
  end

  def tranca_round_source_id(championship_id, phase, round_number)
    "tranca-round-#{championship_id}-#{phase}-#{round_number}"
  end

  def tranca_round_label(phase, round_number)
    phase_label = case phase.to_s
    when "classificatoria" then "Classificatória"
    when "mata_mata" then "Mata-mata"
    else phase.to_s.tr("_", " ").humanize
    end

    round_number.to_i.positive? ? "Rodada #{round_number} · #{phase_label}" : phase_label
  end

  def tranca_mesa_source_id(match_id)
    "tranca-mesa-#{match_id}"
  end

  def tranca_mesa_status_for(status)
    case status.to_s
    when "em_andamento" then "ocupada"
    when "finalizado" then "finalizada"
    else "disponivel"
    end
  end

  def insert_row(table_name, attrs)
    columns = attrs.keys
    values = columns.map { |column| quote_value(attrs[column]) }

    execute <<~SQL
      INSERT INTO #{table_name} (#{columns.join(", ")})
      VALUES (#{values.join(", ")})
    SQL
  end

  def quote_value(value)
    return "NULL" if value.nil?
    return quote(value.to_json) if value.is_a?(Hash) || value.is_a?(Array)

    quote(value)
  end
end
