require "test_helper"

class PhaseFivePlatformTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    @editor = users(:two)
    sign_in @admin

    @championship_1 = Championship.create!(
      source_id: "champ-platform-1",
      name: "Campeonato Plataforma 1",
      season: 2025
    )

    @championship_2 = Championship.create!(
      source_id: "champ-platform-2",
      name: "Campeonato Plataforma 2",
      season: 2026,
      format: { "mode" => "mata_mata" }
    )

    @championship_tranca = Championship.create!(
      source_id: "champ-platform-tranca",
      name: "Campeonato Plataforma Tranca",
      season: 2026,
      modality: :tranca,
      format: { "mode" => "pontuacao" }
    )

    ChampionshipMembership.create!(
      source_id: "cm-1",
      championship: @championship_2,
      user: @editor,
      role: :editor
    )
  end

  test "selects active championship by endpoint" do
    post active_championship_path, params: { championship_id: @championship_2.id }

    assert_response :success
    assert_equal @championship_2.id, JSON.parse(response.body).fetch("id")

    get active_championship_path

    assert_response :success
    assert_equal @championship_2.id, JSON.parse(response.body).fetch("id")
  end

  test "shows the championship setup flow on a dedicated page" do
    get setup_championship_path(@championship_2)

    assert_response :success
    assert_includes response.body, "Configuração do campeonato"
    assert_includes response.body, "Etapa 1. Dados"
    assert_includes response.body, "/championships/#{@championship_2.to_param}/configuracao?step=format"
    refute_includes response.body, 'name="championship[name]"'
    refute_includes response.body, 'name="championship[season]"'
    refute_includes response.body, "Portal aberto"
  end

  test "shows the knockout draw button on mata-mata championships" do
    get setup_championship_path(@championship_2, step: "teams")

    assert_response :success
    assert_includes response.body, "Sortear 1ª rodada"
    assert_includes response.body, "Vincular equipes"
  end

  test "shows categories and teams instead of players in tranca onboarding" do
    get setup_championship_path(@championship_tranca, step: "teams")

    assert_response :success
    assert_includes response.body, "Etapa 4. Duplas"
    assert_includes response.body, "Categoria padrão"
    refute_includes response.body, "Jogadores"
  end

  test "shows duplicate action inside the categories modal" do
    available_category = Category.create!(
      source_id: "cat-phase-five-modal-duplicate",
      championship: @championship_2,
      name: "Sub 16",
      gender: :misto
    )

    get setup_championship_path(@championship_tranca, step: "teams")

    assert_response :success
    assert_includes response.body, available_category.name
    assert_includes response.body, "duplicate-category-modal"
    assert_includes response.body, "openCategoryDuplicateModal"
  end

  test "duplicates a category from the onboarding modal without linking it to the championship" do
    source_category = Category.create!(
      source_id: "cat-phase-five-modal-return",
      championship: @championship_2,
      name: "Sub 17",
      gender: :misto
    )

    post active_championship_path, params: { championship_id: @championship_tranca.id }

    assert_difference -> { Category.count }, 1 do
      post duplicate_category_path(source_category), params: {
        from_modal: "categories",
        name: "Sub 17 Copia"
      }
    end

    duplicated_category = Category.order(:created_at).last
    assert_nil duplicated_category.championship_id
    assert_equal "Sub 17 Copia", duplicated_category.name
    assert_redirected_to setup_championship_path(@championship_tranca, step: "teams", modal: "categories", highlight_category_id: duplicated_category.id)
    assert_equal "Categoria duplicada e disponível para vinculação.", flash[:notice]
  end

  test "shows the publish step with the public invite copy button" do
    get setup_championship_path(@championship_2, step: "publish")

    assert_response :success
    assert_includes response.body, "Etapa 5. Ativação e link público"
    assert_includes response.body, "Entradas no link"
    assert_includes response.body, "data-controller=\"clipboard\""
    assert_includes response.body, "data-action=\"click->clipboard#copy\""
    assert_includes response.body, "data-clipboard-value"
  end

  test "does not show tiebreakers on tranca onboarding" do
    get setup_championship_path(@championship_tranca, step: "format")

    assert_response :success
    refute_includes response.body, "Critérios de desempate"
  end

  test "shows duplas language instead of athletes in tranca registrations" do
    get setup_championship_path(@championship_tranca, step: "registrations")

    assert_response :success
    assert_includes response.body, "Configurar duplas"
    assert_includes response.body, "Inscrições de duplas pelo site do campeonato"
    assert_includes response.body, "Integrantes por dupla"
    refute_includes response.body, "Inscrições de atletas"
    refute_includes response.body, "Ficha de inscrição de atletas"
    refute_includes response.body, "Permissões do técnico"
  end

  test "creates the default tranca category automatically on the teams step" do
    get setup_championship_path(@championship_tranca, step: "teams")

    assert_response :success
    assert_equal 1, @championship_tranca.reload.categories.count
    category = @championship_tranca.categories.first
    assert_equal @championship_tranca.name, category.name
    assert_includes response.body, "Categoria padrão"
    assert_includes response.body, @championship_tranca.name
  end

  test "shows selectable recent tranca duplas in the invite modal" do
    source_championship = Championship.create!(
      source_id: "champ-platform-tranca-source",
      name: "Campeonato Tranca Base",
      season: 2025,
      modality: :tranca,
      status: :finalizado
    )

    source_category = Category.create!(
      source_id: "cat-platform-tranca-source",
      championship: source_championship,
      name: "Livre"
    )

    entity = Entity.create!(
      source_id: "entity-platform-tranca-source",
      name: "Escola Base"
    )

    source_team = Team.create!(
      source_id: "team-platform-tranca-source",
      entity: entity,
      category: source_category,
      name: "Dupla Base",
      registration_status: :aprovada,
      finance_status: :pago
    )

    Athlete.create!(
      source_id: "athlete-platform-tranca-source",
      team: source_team,
      category: source_category,
      name: "Atleta Base",
      status: :validado
    )

    inactive_team = Team.create!(
      source_id: "team-platform-tranca-source-inactive",
      entity: entity,
      category: source_category,
      name: "Dupla Inativa",
      registration_status: :aprovada,
      finance_status: :pago
    )
    Tranca::Dupla.find_by!(source_id: inactive_team.source_id).update!(status: :inativo)

    get setup_championship_path(@championship_tranca, step: "teams")

    invite_modal = Nokogiri::HTML(response.body).at_css("#invite-tranca-duplas-modal")

    assert_response :success
    assert_includes response.body, "Selecionar duplas"
    assert_includes response.body, "Selecionar todas"
    assert_includes response.body, "data-action=\"click->invite-tranca-duplas#toggleAll\""
    assert_includes response.body, "team_ids[]"
    assert_includes invite_modal.text, "Campeonato Tranca Base"
    assert_includes invite_modal.text, "Dupla Base"
    refute_includes invite_modal.text, "Dupla Inativa"
  end

  test "invites selected recent tranca duplas into the onboarding category as pending" do
    source_championship = Championship.create!(
      source_id: "champ-platform-tranca-source-2",
      name: "Campeonato Tranca Base 2",
      season: 2025,
      modality: :tranca,
      status: :finalizado
    )

    source_category = Category.create!(
      source_id: "cat-platform-tranca-source-2",
      championship: source_championship,
      name: "Livre"
    )

    entity = Entity.create!(
      source_id: "entity-platform-tranca-source-2",
      name: "Escola Base 2"
    )

    source_team = Team.create!(
      source_id: "team-platform-tranca-source-2",
      entity: entity,
      category: source_category,
      name: "Dupla Base 2",
      registration_status: :aprovada,
      finance_status: :pago
    )

    Athlete.create!(
      source_id: "athlete-platform-tranca-source-2",
      team: source_team,
      category: source_category,
      name: "Atleta Base 2",
      status: :validado
    )

    get setup_championship_path(@championship_tranca, step: "teams")

    assert_difference -> { @championship_tranca.reload.categories.first.teams.count }, 1 do
      post invite_recent_tranca_duplas_championship_path(@championship_tranca), params: {
        team_ids: [ source_team.id ]
      }
    end

    assert_no_difference -> { @championship_tranca.reload.categories.first.teams.count } do
      post invite_recent_tranca_duplas_championship_path(@championship_tranca), params: {
        team_ids: [ source_team.id ]
      }
    end

    assert_redirected_to setup_championship_path(@championship_tranca, step: "teams")
    onboarding_category = @championship_tranca.reload.categories.first
    invited_team = onboarding_category.teams.order(:created_at).last

    assert invited_team.registration_status_pendente?
    assert_equal onboarding_category, invited_team.category
    assert_equal 1, invited_team.athletes.count
    assert_equal "Atleta Base 2", invited_team.athletes.first.name
    assert_equal 1, invited_team.team_athletes.count
  end

  test "shows a single status badge in compact team cards" do
    category = Category.create!(
      source_id: "cat-phase-five-compact-team-card",
      championship: @championship_2,
      name: "Livre"
    )

    entity = Entity.create!(
      source_id: "entity-phase-five-compact-team-card",
      name: "Escola Compacta"
    )

    Team.create!(
      source_id: "team-phase-five-compact-team-card",
      entity: entity,
      category: category,
      name: "Time Compacto",
      registration_status: :aprovada,
      finance_status: :pendente
    )

    get setup_championship_path(@championship_2, step: "teams")

    assert_response :success
    assert_equal 1, response.body.scan("Aprovada").size
    assert_not_includes response.body, "Pendente"
  end

  test "does not show the removed rule summary cards on the format step" do
    get setup_championship_path(@championship_2, step: "format")

    assert_response :success
    refute_includes response.body, "Regra aplicada"
    refute_includes response.body, "Pontuação e desempate"
    assert_includes response.body, 'name="championship[format][mode]"'
    assert_includes response.body, 'value="mata_mata"'
    assert_includes response.body, 'value="grupos_mata_mata"'
  end

  test "can finalize registrations and generate the initial schedule" do
    category = Category.create!(
      source_id: "cat-phase-five-finalize-registrations",
      championship: @championship_1,
      name: "Sub 20"
    )

    entity = Entity.create!(
      source_id: "entity-phase-five-finalize-registrations",
      name: "Escola Final"
    )

    4.times do |index|
      Team.create!(
        source_id: "team-phase-five-finalize-registrations-#{index + 1}",
        entity: entity,
        category: category,
        name: "Time Final #{index + 1}"
      )
    end

    get championship_path(@championship_1)
    assert_response :success
    assert_includes response.body, "Finalizar inscrições"

    assert_difference -> { Match.where(championship: @championship_1, phase: "grupos").count }, 6 do
      patch finalize_registrations_championship_path(@championship_1)
    end

    assert_redirected_to championship_path(@championship_1)
    assert_not @championship_1.reload.team_signup_enabled?
    assert_equal "em_andamento", @championship_1.status
  end

  test "autosaves championship setup fields without redirecting" do
    patch championship_path(@championship_2), params: {
      autosave: "1",
      current_step: "data",
      championship: {
        registration_start: "2026-09-01",
        registration_end: "2026-09-10",
        start_date: "2026-09-20",
        end_date: "2026-10-20"
      }
    }

    assert_response :no_content
    championship = @championship_2.reload
    assert_equal Date.new(2026, 9, 1), championship.registration_start
    assert_equal Date.new(2026, 9, 10), championship.registration_end
    assert_equal Date.new(2026, 9, 20), championship.start_date
    assert_equal Date.new(2026, 10, 20), championship.end_date
  end

  test "saves championship setup fields when advancing to the next step" do
    patch championship_path(@championship_2), params: {
      current_step: "data",
      step: "format",
      championship: {
        registration_start: "2026-09-02",
        registration_end: "2026-09-11",
        start_date: "2026-09-21",
        end_date: "2026-10-21"
      }
    }

    assert_redirected_to setup_championship_path(@championship_2, step: "format")

    championship = @championship_2.reload
    assert_equal Date.new(2026, 9, 2), championship.registration_start
    assert_equal Date.new(2026, 9, 11), championship.registration_end
    assert_equal Date.new(2026, 9, 21), championship.start_date
    assert_equal Date.new(2026, 10, 21), championship.end_date
  end

  test "advances from format to registrations in the setup flow" do
    patch championship_path(@championship_2), params: {
      current_step: "format",
      step: "registrations",
      championship: {
        format: { mode: "mata_mata" }
      }
    }

    assert_redirected_to setup_championship_path(@championship_2, step: "registrations")
    assert_equal "mata_mata", @championship_2.reload.format_data["mode"]
  end

  test "keeps the tranca teams step focused and removes the public link noise" do
    get setup_championship_path(@championship_tranca, step: "teams")

    assert_response :success
    assert_includes response.body, "Etapa 4. Duplas"
    assert_includes response.body, "Duplas vinculadas"
    assert_includes response.body, "/championships/#{@championship_tranca.to_param}/configuracao?step=publish"
    assert_includes response.body, "Próxima etapa"
    refute_includes response.body, "Convite público"
    refute_includes response.body, "Campos"
    refute_includes response.body, "Árbitros"
  end

  test "can attach and detach a venue from the championship" do
    venue = Venue.create!(
      source_id: "venue-phase-five-detach",
      name: "CAMPO LIVRE"
    )

    patch attach_venue_path(venue), params: { championship_id: @championship_2.id }
    assert_response :redirect
    assert_equal @championship_2, venue.reload.championship

    patch detach_venue_path(venue), params: { championship_id: @championship_2.id }
    assert_response :redirect
    assert_nil venue.reload.championship
  end

  test "can attach and detach a referee from the championship" do
    referee = Referee.create!(
      source_id: "ref-phase-five-detach",
      name: "ÁRBITRO LIVRE"
    )

    patch attach_referee_path(referee), params: { championship_id: @championship_2.id }
    assert_response :redirect
    assert_equal @championship_2, referee.reload.championship

    patch detach_referee_path(referee), params: { championship_id: @championship_2.id }
    assert_response :redirect
    assert_nil referee.reload.championship
  end

  test "draws the first knockout round from category teams" do
    category = Category.create!(
      source_id: "cat-phase-five-knockout",
      championship: @championship_2,
      name: "Sub 12"
    )

    entity = Entity.create!(
      source_id: "entity-phase-five-knockout",
      name: "Escola K"
    )

    team_1 = Team.create!(
      source_id: "team-phase-five-knockout-1",
      entity: entity,
      category: category,
      name: "Time K 1"
    )

    team_2 = Team.create!(
      source_id: "team-phase-five-knockout-2",
      entity: entity,
      category: category,
      name: "Time K 2"
    )

    assert_difference -> { Match.where(championship: @championship_2, phase: "mata_mata", round_number: 1).count }, 1 do
      post draw_knockout_round_championship_path(@championship_2)
    end

    assert_redirected_to setup_championship_path(@championship_2, step: "teams")
    match = Match.find_by(championship: @championship_2, phase: "mata_mata", round_number: 1)
    assert_equal category, match.category
    assert_includes [ team_1, team_2 ], match.team_a
    assert_includes [ team_1, team_2 ], match.team_b
  end

  test "shows the generated knockout key after the draw" do
    category = Category.create!(
      source_id: "cat-phase-five-knockout-view",
      championship: @championship_2,
      name: "Sub 14"
    )

    entity = Entity.create!(
      source_id: "entity-phase-five-knockout-view",
      name: "Escola V"
    )

    team_1 = Team.create!(
      source_id: "team-phase-five-knockout-view-1",
      entity: entity,
      category: category,
      name: "Time V 1"
    )

    team_2 = Team.create!(
      source_id: "team-phase-five-knockout-view-2",
      entity: entity,
      category: category,
      name: "Time V 2"
    )

    @championship_2.draw_initial_knockout_round!

    get setup_championship_path(@championship_2, step: "teams")

    assert_response :success
    assert_includes response.body, "A primeira rodada já foi gerada."
    assert_includes response.body, "Sorteio inicial"
    assert_includes response.body, "Rodada 1"
    assert_includes response.body, "Time V 1"
    assert_includes response.body, "Time V 2"
    refute_includes response.body, "Sortear 1ª rodada"
  end

  test "can finalize onboarding from the teams step" do
    category = Category.create!(
      source_id: "cat-phase-five-knockout-finalize",
      championship: @championship_2,
      name: "Sub 16"
    )

    entity = Entity.create!(
      source_id: "entity-phase-five-knockout-finalize",
      name: "Escola F"
    )

    Team.create!(
      source_id: "team-phase-five-knockout-finalize-1",
      entity: entity,
      category: category,
      name: "Time F 1"
    )

    Team.create!(
      source_id: "team-phase-five-knockout-finalize-2",
      entity: entity,
      category: category,
      name: "Time F 2"
    )

    @championship_2.draw_initial_knockout_round!

    patch finalize_onboarding_championship_path(@championship_2)

    assert_redirected_to championship_path(@championship_2)
    assert_equal "em_andamento", @championship_2.reload.status
  end

  test "can attach an existing team to a championship category" do
    destination_category = Category.create!(
      source_id: "cat-phase-five-destination",
      championship: @championship_2,
      name: "Sub 13"
    )

    other_championship = Championship.create!(
      source_id: "champ-phase-five-other",
      name: "Campeonato Base",
      season: 2024
    )

    source_category = Category.create!(
      source_id: "cat-phase-five-source",
      championship: other_championship,
      name: "Sub 15"
    )

    entity = Entity.create!(
      source_id: "entity-phase-five-attach-team",
      name: "Escola T"
    )

    team = Team.create!(
      source_id: "team-phase-five-attach-team",
      entity: entity,
      category: source_category,
      name: "Time T"
    )

    second_team = Team.create!(
      source_id: "team-phase-five-attach-team-2",
      entity: entity,
      category: source_category,
      name: "Time U"
    )

    patch attach_team_championship_path(@championship_2), params: {
      team_ids: [ team.id, second_team.id ],
      category_id: destination_category.id
    }

    assert_redirected_to setup_championship_path(@championship_2, step: "teams")
    assert_equal destination_category, team.reload.category
    assert_equal destination_category, second_team.reload.category
  end

  test "sets tranca teams to pending when attaching them to a category" do
    destination_category = Category.create!(
      source_id: "cat-phase-five-tranca-destination",
      championship: @championship_tranca,
      name: "Livre"
    )

    other_championship = Championship.create!(
      source_id: "champ-phase-five-tranca-other",
      name: "Campeonato Auxiliar",
      season: 2024
    )

    source_category = Category.create!(
      source_id: "cat-phase-five-tranca-source",
      championship: other_championship,
      name: "Sub 17"
    )

    entity = Entity.create!(
      source_id: "entity-phase-five-tranca-attach-team",
      name: "Escola Tranca"
    )

    team = Team.create!(
      source_id: "team-phase-five-tranca-attach-team",
      entity: entity,
      category: source_category,
      name: "Dupla Tranca",
      registration_status: :aprovada
    )

    patch attach_team_championship_path(@championship_tranca), params: {
      team_id: team.id,
      category_id: destination_category.id
    }

    assert_redirected_to setup_championship_path(@championship_tranca, step: "teams")
    assert_equal destination_category, team.reload.category
    assert team.registration_status_pendente?
  end

  test "duplicates a category into a new available copy with pending duplas" do
    source_championship = Championship.create!(
      source_id: "champ-phase-five-category-source",
      name: "Campeonato Origem",
      season: 2024
    )

    source_category = Category.create!(
      source_id: "cat-phase-five-category-source",
      championship: source_championship,
      name: "Sub 18",
      gender: :misto
    )

    entity = Entity.create!(
      source_id: "entity-phase-five-category-dup",
      name: "Escola D"
    )

    source_team = Team.create!(
      source_id: "team-phase-five-category-dup",
      entity: entity,
      category: source_category,
      name: "Dupla D",
      registration_status: :aprovada,
      finance_status: :pago
    )

    Athlete.create!(
      source_id: "athlete-phase-five-category-dup",
      team: source_team,
      category: source_category,
      name: "Atleta D",
      status: :validado
    )

    post active_championship_path, params: { championship_id: @championship_tranca.id }

    assert_no_difference -> { @championship_tranca.reload.categories.count } do
      assert_difference -> { Category.count }, 1 do
        post duplicate_category_path(source_category), params: {
          from_modal: "categories",
          name: "Sub 18 Copia"
        }
      end
    end

    duplicated_category = Category.order(:created_at).last
    assert_nil duplicated_category.championship_id
    assert_equal "Sub 18 Copia", duplicated_category.name
    assert_equal 1, duplicated_category.teams.count

    duplicated_team = duplicated_category.teams.order(:created_at).last
    assert duplicated_team.registration_status_pendente?
    assert duplicated_team.finance_status_pendente?
    assert_equal 1, duplicated_team.athletes.count
    assert_equal "Atleta D", duplicated_team.athletes.order(:created_at).last.name
    assert duplicated_team.athletes.order(:created_at).last.status_pendente?

    follow_redirect!

    assert_response :success
    assert_includes response.body, "Novo"
  end

  test "shows duplicate action for categories already linked to the active championship" do
    linked_category = Category.create!(
      source_id: "cat-phase-five-category-linked",
      championship: @championship_2,
      name: "Sub 20",
      gender: :misto
    )

    post active_championship_path, params: { championship_id: @championship_2.id }

    get categories_path

    assert_response :success
    assert_includes response.body, "Duplicar"
  end

  test "allows inline renaming of a category on the show page" do
    category = Category.create!(
      source_id: "cat-phase-five-inline-edit",
      championship: @championship_2,
      name: "Sub 20"
    )

    get category_path(category)

    assert_response :success
    assert_includes response.body, "Edição inline"
    assert_includes response.body, "Título editável"
    assert_includes response.body, "Salvar nome"

    patch category_path(category), params: {
      commit: "Salvar nome",
      category: {
        name: "Sub 20 Atualizada"
      }
    }

    assert_redirected_to category_path(category)
    assert_equal "Sub 20 Atualizada", category.reload.name
  end

  test "forbids selecting championship without access" do
    sign_in @editor

    post active_championship_path, params: { championship_id: @championship_1.id }

    assert_response :forbidden
  end

  test "admin can create championship membership" do
    post championship_championship_memberships_path(@championship_1), params: {
      championship_membership: {
        source_id: "cm-2",
        user_id: @editor.id,
        role: "leitor"
      }
    }

    assert_response :created
    assert_equal "leitor", JSON.parse(response.body).fetch("role")
  end

  test "dashboard exposes accessible championships for regular users" do
    sign_in @editor

    get root_path

    assert_response :success
  end
end
