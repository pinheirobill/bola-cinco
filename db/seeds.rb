require "json"

def clear_seed_data!
  tables = ActiveRecord::Base.connection.tables - %w[users schema_migrations ar_internal_metadata]

  ActiveRecord::Base.connection.disable_referential_integrity do
    tables.each do |table_name|
      ActiveRecord::Base.connection.execute("DELETE FROM #{ActiveRecord::Base.connection.quote_table_name(table_name)}")
    end
  end
end

clear_seed_data!

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

  championship
end

if ENV["BOLA_CINCO_BOOTSTRAP_CHAMPIONSHIPS"] == "1"
  import_championship_snapshot!(Rails.root.join("db/seeds/bola_cinco_import_2026.json"))
  import_championship_snapshot!(Rails.root.join("db/seeds/chis_cup_2026.json"))
  import_championship_snapshot!(Rails.root.join("db/seeds/tranca_2026.json"))

  load Rails.root.join("db/seeds/arbitros_e_campos.rb") if Rails.root.join("db/seeds/arbitros_e_campos.rb").exist?
  load Rails.root.join("db/seeds/demo_athletes_and_goals.rb") if Rails.root.join("db/seeds/demo_athletes_and_goals.rb").exist?
end
