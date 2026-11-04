# Populate the existing MASTER CUP UX preview from the imported youth teams.
# Run with: bin/rails runner 'load "db/seeds/master_cup_2026_ux_preview.rb"'
# The source category mapping follows the preview's age bands. Infantil uses
# the first four Sub 10 teams by name because the preview is configured for four.
preview = Championship.find_by!(source_id: "codex-local-ux-preview-mastercup")

source_categories_by_preview_category = {
  "Pré Mirim" => "Sub 08",
  "Mirim" => "Sub 09",
  "Infantil" => "Sub 10",
  "Juvenil" => "Sub 13"
}

Championship.transaction do
  source_categories_by_preview_category.each do |preview_category_name, source_category_name|
    category = Category.for_championship(preview).find_by!(name: preview_category_name)
    configured_team_count = preview.team_count_for(category)
    source_category = Category.find_by!(name: source_category_name)
    source_teams = source_category.teams.includes(:athletes).order(:name, :id).first(configured_team_count)

    unless source_teams.size == configured_team_count
      raise "#{source_category_name} has #{source_teams.size} teams; #{preview_category_name} needs #{configured_team_count}."
    end

    source_teams.each do |source_team|
      team = Team.find_or_initialize_by(source_id: "master-cup-preview-#{source_team.source_id}")
      team.assign_attributes(
        entity: source_team.entity,
        category: category,
        name: source_team.name,
        short_name: source_team.short_name,
        group_key: source_team.group_key,
        registration_status: :aprovada,
        finance_status: :pago
      )
      team.save!

      source_team.athletes.order(:id).each do |source_athlete|
        athlete = Athlete.find_or_initialize_by(source_id: "master-cup-preview-#{source_athlete.source_id}")
        copied_attributes = source_athlete.attributes.except(
          "id", "source_id", "team_id", "category_id", "user_id", "created_at", "updated_at"
        )
        athlete.assign_attributes(copied_attributes)
        athlete.assign_attributes(team: team, category: category, user: nil)
        athlete.save!
      end
    end
  end

  preview.reload
  preview.categories.each { |category| category.association(:teams).reset }
  preview.finalize_registrations! if preview.matches.none?
  preview.rebuild_standings!
end

puts "#{preview.name}: #{preview.categories.count} categorias, #{preview.teams.distinct.count} equipes, #{preview.athletes.distinct.count} atletas e #{preview.matches.count} jogos."
