require "csv"

csv_path = Rails.root.join("db/seeds/atletas_categoria_1.csv")
raise ArgumentError, "Missing seed CSV: #{csv_path}" unless csv_path.exist?

def blank_to_nil(value)
  value.to_s.strip.presence
end

def parse_date(value)
  return if value.blank?

  Date.strptime(value.to_s, "%d/%m/%y")
end

def parse_time(value)
  return if value.blank?

  Time.zone.strptime(value.to_s, "%d/%m/%y %H:%M:%S")
end

def normalize_shirt_number(value)
  cleaned = value.to_s.strip
  return nil if cleaned.blank? || cleaned == "0"

  cleaned
end

championship = Championship.find_or_initialize_by(source_id: "seed-atletas-categoria-1")
championship.update!(
  name: "Atletas Categoria 1",
  season: 2026,
  status: :em_andamento
)

category = Category.find_or_initialize_by(source_id: "seed-atletas-categoria-1-categoria-1")
category.update!(
  championship: championship,
  name: "Categoria 1"
)
ChampionshipCategory.find_or_create_by!(championship: championship, category: category) do |membership|
  membership.source_id = "championship-category-#{championship.id}-#{category.id}"
end

CSV.foreach(csv_path, headers: true) do |row|
  team_name = row.fetch("team_name").to_s.strip
  entity_source_id = "seed-atletas-categoria-1-entity-#{team_name.parameterize}"
  team_source_id = "seed-atletas-categoria-1-team-#{team_name.parameterize}"

  entity = Entity.find_or_initialize_by(source_id: entity_source_id)
  entity.update!(
    name: team_name
  )

  team = Team.find_or_initialize_by(source_id: team_source_id)
  team.update!(
    entity: entity,
    category: category,
    name: team_name,
    short_name: team_name,
    registration_status: :aprovada,
    finance_status: :pago
  )

  athlete = Athlete.find_or_initialize_by(source_id: "seed-atletas-categoria-1-athlete-#{row.fetch("matricula")}")
  athlete.update!(
    team: team,
    category: category,
    name: row.fetch("name"),
    status: row.fetch("status").to_s == "active" ? :validado : :pendente,
    photo_url: blank_to_nil(row["photo_url"]),
    document: blank_to_nil(row["cpf"]) || blank_to_nil(row["rg"]),
    cpf: blank_to_nil(row["cpf"]),
    rg: blank_to_nil(row["rg"]),
    birth_certificate: blank_to_nil(row["birth_certificate"]),
    birth_date: parse_date(row["birth_date"]),
    shirt_number: normalize_shirt_number(row["shirt_number"]),
    cell_phone: blank_to_nil(row["cell_phone"]),
    email: blank_to_nil(row["email"]),
    passport: nil,
    voter_id: blank_to_nil(row["voter_id"]),
    gender: nil,
    position: blank_to_nil(row["position"]),
    documents_count: row["documents_count"].to_i,
    registration_submitted_at: parse_time(row["registered_at"])
  )
end
