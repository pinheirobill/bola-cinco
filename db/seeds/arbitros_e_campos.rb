championship = Championship.find_or_create_by!(source_id: "copa-bola-5-37-interescolas-futsal-2026") do |record|
  record.name = "COPA BOLA 5 - 37ª INTERESCOLAS DE FUTSAL - 2026"
  record.season = 2026
  record.status = :em_andamento
end

referees = [
  "ROSIVALDO DE SOUSA",
  "WELLITON GALDINO",
  "RICARDO BRAGOU",
  "ROGERIO PAULINO"
]

referees.each do |name|
  referee = championship.referees.find_or_initialize_by(source_id: "seed-referee-#{name.parameterize}")
  referee.update!(
    name: name,
    status: :ativo
  )
end

venues = [
  "INTERLAGOS",
  "ACRE"
]

venues.each do |name|
  venue = championship.venues.find_or_initialize_by(source_id: "seed-venue-#{name.parameterize}")
  venue.update!(
    name: name,
    status: :ativo
  )
end
