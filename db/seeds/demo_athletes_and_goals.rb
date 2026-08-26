championship = Championship.find_by!(source_id: "copa-bola-5-37-interescolas-futsal-2026")

demo_athletes = [
  {
    source_id: "seed-demo-athlete-sub-11-col-anglo-1",
    team_source_id: "sub-11-col-anglo-morumbi",
    name: "Lucas Almeida",
    shirt_number: "7",
    position: "Atacante",
    birth_date: Date.new(2012, 3, 14)
  },
  {
    source_id: "seed-demo-athlete-sub-11-col-anglo-2",
    team_source_id: "sub-11-col-anglo-morumbi",
    name: "Theo Martins",
    shirt_number: "10",
    position: "Meia",
    birth_date: Date.new(2012, 8, 2)
  },
  {
    source_id: "seed-demo-athlete-sub-11-acesos-1",
    team_source_id: "sub-11-academy-acesos",
    name: "Gabriel Nunes",
    shirt_number: "9",
    position: "Atacante",
    birth_date: Date.new(2012, 11, 19)
  },
  {
    source_id: "seed-demo-athlete-sub-10-col-anglo-1",
    team_source_id: "sub-10-col-anglo-morumbi",
    name: "Enzo Ribeiro",
    shirt_number: "8",
    position: "Atacante",
    birth_date: Date.new(2011, 5, 7)
  },
  {
    source_id: "seed-demo-athlete-sub-10-col-anglo-2",
    team_source_id: "sub-10-col-anglo-morumbi",
    name: "Pedro Nogueira",
    shirt_number: "11",
    position: "Meia",
    birth_date: Date.new(2011, 9, 23)
  },
  {
    source_id: "seed-demo-athlete-sub-10-tcp-1",
    team_source_id: "sub-10-tenis-clube-paulista",
    name: "Rafael Lima",
    shirt_number: "5",
    position: "Zagueiro",
    birth_date: Date.new(2011, 2, 11)
  },
  {
    source_id: "seed-demo-athlete-sub-08-beit-1",
    team_source_id: "sub-08-col-beit-yaacov",
    name: "Noah Benveniste",
    shirt_number: "1",
    position: "Goleiro",
    birth_date: Date.new(2013, 1, 28)
  },
  {
    source_id: "seed-demo-athlete-sub-08-wp-1",
    team_source_id: "sub-08-w-p-sports",
    name: "Henrique Alves",
    shirt_number: "6",
    position: "Atacante",
    birth_date: Date.new(2013, 4, 9)
  },
  {
    source_id: "seed-demo-athlete-sub-08-wp-2",
    team_source_id: "sub-08-w-p-sports",
    name: "Caio Barbosa",
    shirt_number: "4",
    position: "Meia",
    birth_date: Date.new(2013, 7, 18)
  }
]

athletes_by_source_id = {}

demo_athletes.each do |attrs|
  team = Team.find_by!(source_id: attrs.fetch(:team_source_id))
  athlete = Athlete.find_or_initialize_by(source_id: attrs.fetch(:source_id))
  athlete.update!(
    team: team,
    category: team.category,
    name: attrs.fetch(:name),
    shirt_number: attrs.fetch(:shirt_number),
    position: attrs.fetch(:position),
    birth_date: attrs.fetch(:birth_date),
    status: :validado,
    documents_count: 0,
    registration_submitted_at: Time.zone.local(2026, 8, 24, 12, 0, 0)
  )
  athletes_by_source_id[athlete.source_id] = athlete
end

%w[match-001 match-002 match-003].each do |match_source_id|
  Match.find_by!(source_id: match_source_id).touch
end

goal_events = [
  { match_source_id: "match-001", athlete_source_id: "seed-demo-athlete-sub-11-col-anglo-1", minute: 4, index: 1 },
  { match_source_id: "match-001", athlete_source_id: "seed-demo-athlete-sub-11-col-anglo-2", minute: 11, index: 2 },
  { match_source_id: "match-001", athlete_source_id: "seed-demo-athlete-sub-11-col-anglo-1", minute: 19, index: 3 },
  { match_source_id: "match-001", athlete_source_id: "seed-demo-athlete-sub-11-col-anglo-2", minute: 31, index: 4 },
  { match_source_id: "match-002", athlete_source_id: "seed-demo-athlete-sub-10-col-anglo-1", minute: 6, index: 1 },
  { match_source_id: "match-002", athlete_source_id: "seed-demo-athlete-sub-10-col-anglo-2", minute: 14, index: 2 },
  { match_source_id: "match-002", athlete_source_id: "seed-demo-athlete-sub-10-col-anglo-1", minute: 27, index: 3 },
  { match_source_id: "match-003", athlete_source_id: "seed-demo-athlete-sub-08-wp-1", minute: 3, index: 1 },
  { match_source_id: "match-003", athlete_source_id: "seed-demo-athlete-sub-08-wp-2", minute: 8, index: 2 },
  { match_source_id: "match-003", athlete_source_id: "seed-demo-athlete-sub-08-wp-1", minute: 12, index: 3 },
  { match_source_id: "match-003", athlete_source_id: "seed-demo-athlete-sub-08-wp-2", minute: 17, index: 4 },
  { match_source_id: "match-003", athlete_source_id: "seed-demo-athlete-sub-08-wp-1", minute: 23, index: 5 },
  { match_source_id: "match-003", athlete_source_id: "seed-demo-athlete-sub-08-wp-2", minute: 30, index: 6 }
]

goal_events.each do |attrs|
  match = Match.find_by!(source_id: attrs.fetch(:match_source_id))
  athlete = athletes_by_source_id.fetch(attrs.fetch(:athlete_source_id))
  event = match.match_events.find_or_initialize_by(source_id: "seed-#{attrs.fetch(:match_source_id)}-goal-#{attrs.fetch(:index)}")
  event.update!(
    championship: championship,
    match: match,
    team: athlete.team,
    athlete: athlete,
    kind: :gol,
    minute: attrs.fetch(:minute),
    notes: "Gol de demo para #{athlete.name}",
    source_data: {
      "seeded" => true
    }
  )
end
