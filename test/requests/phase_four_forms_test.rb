require "test_helper"
require "base64"

class PhaseFourFormsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user

    @championship = Championship.create!(
      source_id: "champ-phase-four",
      name: "Campeonato Fase 4",
      season: 2026
    )

    @category = Category.create!(
      source_id: "cat-phase-four",
      championship: @championship,
      name: "Sub 19"
    )

    @entity = Entity.create!(
      source_id: "entity-phase-four",
      name: "Equipe Fase 4"
    )

    @team = Team.create!(
      source_id: "team-phase-four",
      entity: @entity,
      category: @category,
      name: "Equipe Fase 4"
    )

    @entity_b = Entity.create!(
      source_id: "entity-phase-four-b",
      name: "Equipe Fase 4 B"
    )

    @team_b = Team.create!(
      source_id: "team-phase-four-b",
      entity: @entity_b,
      category: @category,
      name: "Equipe Fase 4 B"
    )

    @entity_c = Entity.create!(
      source_id: "entity-phase-four-c",
      name: "Equipe Fase 4 C"
    )

    @team_c = Team.create!(
      source_id: "team-phase-four-c",
      entity: @entity_c,
      category: @category,
      name: "Equipe Fase 4 C"
    )

    @entity_d = Entity.create!(
      source_id: "entity-phase-four-d",
      name: "Equipe Fase 4 D"
    )

    @team_d = Team.create!(
      source_id: "team-phase-four-d",
      entity: @entity_d,
      category: @category,
      name: "Equipe Fase 4 D"
    )

    @athlete = Athlete.create!(
      source_id: "athlete-phase-four",
      team: @team,
      category: @category,
      name: "Atleta Fase 4"
    )

    @athlete_b = Athlete.create!(
      source_id: "athlete-phase-four-b",
      team: @team_b,
      category: @category,
      name: "Atleta Fase 4 B"
    )

    @athlete_c = Athlete.create!(
      source_id: "athlete-phase-four-c",
      team: @team,
      category: @category,
      name: "Atleta Fase 4 C"
    )

    @match = Match.create!(
      source_id: "match-phase-four",
      championship: @championship,
      category: @category,
      code: "M1",
      phase: "grupos"
    )

    @referee = Referee.create!(
      source_id: "ref-phase-four",
      championship: @championship,
      name: "Árbitro Fase 4"
    )
  end

  test "creates a venue from html form" do
    post venues_path, params: {
      championship_id: @championship.id,
      venue: {
        name: "Ginásio Fase 4",
        city: "São Paulo",
        status: "ativo"
      },
      commit: "Criar local"
    }

    assert_redirected_to venue_path(Venue.find_by(name: "Ginásio Fase 4"))
  end

  test "creates a match report from html form" do
    post match_match_reports_path(@match), params: {
      match_report: {
        referee_id: @referee.id
      },
      commit: "Salvar relatório"
    }

    assert_redirected_to match_path(@match)
    report = @match.reload.match_report
    assert_equal "rascunho", report.status
    assert_equal @referee, report.referee
    assert report.submitted_at.present?
    assert_nil report.approved_at
  end

  test "shows the match onboarding with report and event sections" do
    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    get match_path(@match)

    assert_response :success
    assert_includes response.body, "Onboarding do jogo"
    assert_includes response.body, "Súmula centralizada"
    assert_includes response.body, "Vencedor"
    refute_includes response.body, "Etapa 2. Relatório de jogo"
    refute_includes response.body, "Etapa 3. Registrar evento"
    assert_includes response.body, @team.name
  end

  test "shows the import button and review screen for a summula photo" do
    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    get match_path(@match)
    assert_includes response.body, "Importar súmula"

    image_path = build_summula_png

    post import_summula_match_path(@match), params: {
      match_summula_import: {
        pdf: Rack::Test::UploadedFile.new(image_path, "image/png")
      }
    }

    assert_response :success
    assert_includes response.body, "Prévia detectada"
    assert_includes response.body, "De / Para"
    assert_includes response.body, "Foto enviada"
    assert_includes response.body, @athlete.name
    assert_includes response.body, "Placar da equipe esquerda"
    assert_includes response.body, "Data do jogo"
    assert_includes response.body, "Confirmar importação"

    document = Nokogiri::HTML(response.body)
    token = document.at_css('input[name="match_summula_import[token]"]')&.[]("value")

    post import_summula_match_path(@match), params: {
      match_summula_import: {
        confirm: "1",
        token: token,
        left_team_id: @team.id,
        right_team_id: @team_b.id,
        score_a: 4,
        score_b: 0,
        scheduled_on: "2026-04-11",
        scheduled_time: "09:08"
      }
    }

    assert_redirected_to match_path(@match)
    @match.reload
    assert_equal 4, @match.score_a
    assert_equal 0, @match.score_b
    assert_equal @team, @match.team_a
    assert_equal @team_b, @match.team_b
  end

  test "creates athletes from confirmed import rows when roster is empty" do
    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    image_path = build_summula_png

    post import_summula_match_path(@match), params: {
      match_summula_import: {
        pdf: Rack::Test::UploadedFile.new(image_path, "image/png")
      }
    }

    document = Nokogiri::HTML(response.body)
    token = document.at_css('input[name="match_summula_import[token]"]')&.[]("value")

    post import_summula_match_path(@match), params: {
      match_summula_import: {
        confirm: "1",
        token: token,
        left_team_id: @team.id,
        right_team_id: @team_b.id,
        rows: {
          left_0: {
            side: "left",
            shirt_number: "11",
            player_name: "Raul Duarte Bueno",
            source_line: "Raul Duarte Bueno 11"
          }
        }
      }
    }

    assert_redirected_to match_path(@match)
    athlete = @team.athletes.find_by(name: "Raul Duarte Bueno")
    assert athlete.present?
    assert_equal "11", athlete.shirt_number
    assert_equal athlete, @match.match_participations.find_by(team: @team, athlete: athlete)&.athlete
  end

  test "shows the paper-like match editor" do
    @match.update!(
      team_a: @team,
      team_b: @team_b,
      score_a: 4,
      score_b: 0
    )

    get edit_match_path(@match)

    assert_response :success
    assert_includes response.body, "Cabeçalho da súmula"
    assert_includes response.body, "Árbitro e súmula"
    assert_includes response.body, "Lançamentos da súmula"
    assert_includes response.body, "Resumo instantâneo"
    refute_includes response.body, "Gols automáticos"
    assert_includes response.body, "Atletas"
    assert_includes response.body, "Cartões"
    assert_includes response.body, "Até 5 tempos da súmula"
    assert_includes response.body, "Gol 1 fica sempre aberto"
    assert_includes response.body, @athlete.name
    assert_includes response.body, @athlete_b.name

    document = Nokogiri::HTML(response.body)
    team_a_goal_inputs = document.css(%(input[name="match[event_sheet][team_a][#{@athlete.id}][goal_minutes][]"]))
    team_b_goal_inputs = document.css(%(input[name="match[event_sheet][team_b][#{@athlete_b.id}][goal_minutes][]"]))

    assert_equal 4, team_a_goal_inputs.size
    assert_equal 1, team_b_goal_inputs.size
  end

  test "shows confirmed match participations even when the athlete is not on the roster" do
    team_c = Team.create!(
      source_id: "team-phase-four-guest",
      entity: Entity.create!(source_id: "entity-phase-four-guest", name: "Equipe Convidada"),
      category: @category,
      name: "Equipe Convidada"
    )

    guest_athlete = Athlete.create!(
      source_id: "athlete-phase-four-guest",
      team: team_c,
      category: @category,
      name: "Atleta Convidado"
    )

    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    post match_match_participations_path(@match), params: {
      return_to: edit_match_path(@match),
      match_participation: {
        team_id: @team.id,
        athlete_ids: [guest_athlete.id]
      }
    }

    assert_redirected_to edit_match_path(@match)

    get edit_match_path(@match)

    assert_response :success
    refute_includes response.body, "Participações confirmadas"
    assert_includes response.body, guest_athlete.name
  end

  test "shows global athletes in the participation modal" do
    team_c = Team.create!(
      source_id: "team-phase-four-c-modal",
      entity: Entity.create!(source_id: "entity-phase-four-c-modal", name: "Equipe Modal C"),
      category: @category,
      name: "Equipe Modal C"
    )

    guest_athlete = Athlete.create!(
      source_id: "athlete-phase-four-modal",
      team: team_c,
      category: @category,
      name: "Atleta Modal Global",
      status: "bloqueado"
    )

    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    get edit_match_path(@match)

    assert_response :success
    assert_includes response.body, "A lista abaixo mostra todos os atletas cadastrados do sistema."
    assert_includes response.body, guest_athlete.name
  end

  test "creates pending participations for the match roster" do
    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    participations = @match.reload.match_participations.order(:team_id, :athlete_id)

    assert_equal 3, participations.count
    assert_equal %w[pendente pendente pendente], participations.pluck(:status)
    assert_equal [@team.id, @team.id, @team_b.id], participations.pluck(:team_id)
    assert_equal [@athlete.id, @athlete_c.id, @athlete_b.id], participations.pluck(:athlete_id)
  end

  test "updates match and report from the paper-like editor" do
    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    patch match_path(@match), params: {
      match: {
        code: "M1A",
        phase: "final",
        scheduled_on: "2026-08-25",
        scheduled_time: "09:30",
        status: "em_andamento",
        team_a_id: @team.id,
        team_b_id: @team_b.id,
        score_a: 2,
        score_b: 1,
        wo: @team_b.name,
        event_sheet: {
          team_a: {
            @athlete.id.to_s => {
              yellow_card: "1",
              red_card: "1",
              goal_minutes: %w[05 12],
              substitution_minutes: %w[18]
            }
          },
          team_b: {
            @athlete_b.id.to_s => {
              goal_minutes: []
            }
          }
        }
      },
      match_report: {
        referee_id: @referee.id
      }
    }

    assert_redirected_to match_path(@match)
    @match.reload
    assert_equal "M1A", @match.code
    assert_equal 2, @match.score_a
    assert_equal @team, @match.winner
    assert_equal @team_b.name, @match.wo
    assert_equal "rascunho", @match.match_report.status
    assert @match.match_report.submitted_at.present?
    assert_nil @match.match_report.approved_at
    goals = @match.match_events.where(kind: "gol").order(:created_at)
    assert_equal [5, 12], goals.pluck(:minute)
    assert_equal [@athlete.id, @athlete.id], goals.pluck(:athlete_id)
    assert_equal ["Gol lançado pela súmula", "Gol lançado pela súmula"], goals.pluck(:notes)
  end

  test "approves a match report from the index" do
    post match_match_reports_path(@match), params: {
      match_report: {
        referee_id: @referee.id
      },
      commit: "Salvar relatório"
    }

    report = @match.reload.match_report

    patch approve_match_report_path(report)

    assert_redirected_to match_reports_path
    report.reload
    assert_equal "aprovado", report.status
    assert report.approved_at.present?
    assert report.submitted_at.present?
  end

  test "creates a match event from the paper-like editor" do
    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    post match_match_events_path(@match), params: {
      match_event: {
        team_id: @team.id,
        athlete_id: @athlete.id,
        kind: "gol",
        minute: 8,
        period: "1º tempo",
        notes: "Gol aberto pela esquerda"
      },
      commit: "Registrar evento"
    }

    assert_redirected_to edit_match_path(@match)
    assert_equal 1, @match.reload.match_events.count
    assert_equal "gol", @match.match_events.last.kind
  end

  test "autosaves the event sheet into match events" do
    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    patch match_path(@match), params: {
      autosave: "1",
      match: {
        code: @match.code,
        phase: @match.phase,
        team_a_id: @team.id,
        team_b_id: @team_b.id,
        event_sheet: {
          team_a: {
            @athlete.id.to_s => {
              yellow_card: "1",
              red_card: "1",
              goal_minutes: "05, 12",
              substitution_minutes: %w[18]
            }
          },
          team_b: {
            @athlete_b.id.to_s => {
              goal_minutes: ""
            }
          }
        }
      }
    }, as: :turbo_stream

    assert_response :success
    @match.reload

    yellow_card = @match.match_events.find_by!(team: @team, athlete: @athlete, kind: "cartao_amarelo")
    red_card = @match.match_events.find_by!(team: @team, athlete: @athlete, kind: "cartao_vermelho")
    goals = @match.match_events.where(kind: "gol").order(:created_at)
    substitutions = @match.match_events.where(kind: "substituicao").order(:created_at)

    assert_equal @team, yellow_card.team
    assert_equal @athlete, yellow_card.athlete
    assert_equal "cartao_amarelo", yellow_card.kind
    assert_equal @team, red_card.team
    assert_equal @athlete, red_card.athlete
    assert_equal "cartao_vermelho", red_card.kind
    assert_equal [5, 12], goals.pluck(:minute)
    assert_equal [18], substitutions.pluck(:minute)
  end

  test "creates a match participation from the match page" do
    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    post match_match_participations_path(@match), params: {
      match_participation: {
        team_id: @team.id,
        athlete_id: @athlete.id,
        status: "confirmado",
        notes: "Titular confirmado"
      }
    }

    assert_redirected_to match_path(@match)
    participation = @match.reload.match_participations.find_by!(team_id: @team.id, athlete_id: @athlete.id)
    assert_equal @athlete.name, participation.athlete_name
    assert_equal "confirmado", participation.status
    assert_equal "Titular confirmado", participation.notes
  end

  test "creates multiple match participations from the match page" do
    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    @match.match_participations.delete_all

    post match_match_participations_path(@match), params: {
      match_participation: {
        team_id: @team.id,
        athlete_ids: [@athlete.id, @athlete_c.id]
      }
    }

    assert_redirected_to match_path(@match)
    participations = @match.reload.match_participations.where(team_id: @team.id).order(:athlete_id)
    assert_equal [@athlete.id, @athlete_c.id], participations.pluck(:athlete_id)
    assert_equal %w[confirmado confirmado], participations.pluck(:status)
  end

  test "confirms existing match participations from the batch modal" do
    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    participation = @match.match_participations.find_by!(team_id: @team.id, athlete_id: @athlete.id)
    assert_equal "pendente", participation.status

    post match_match_participations_path(@match), params: {
      match_participation: {
        team_id: @team.id,
        athlete_ids: [@athlete.id]
      }
    }

    assert_redirected_to match_path(@match)
    assert_equal "confirmado", @match.reload.match_participations.find_by!(team_id: @team.id, athlete_id: @athlete.id).status
  end

  test "re-renders the edit page when batch participation has no team" do
    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    post match_match_participations_path(@match), params: {
      match_participation: {
        team_id: "",
        athlete_ids: [@athlete.id, @athlete_c.id]
      }
    }

    assert_response :unprocessable_entity
    assert_includes response.body, "Cabeçalho da súmula"
    assert_includes response.body, "Adicionar participação"
  end

  test "updates the same match participation instead of duplicating it" do
    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    post match_match_participations_path(@match), params: {
      return_to: edit_match_path(@match),
      match_participation: {
        team_id: @team.id,
        athlete_id: @athlete.id,
        status: "confirmado"
      }
    }

    post match_match_participations_path(@match), params: {
      return_to: edit_match_path(@match),
      match_participation: {
        team_id: @team.id,
        athlete_id: @athlete.id,
        status: "ausente"
      }
    }

    assert_equal 3, @match.reload.match_participations.count
    assert_equal "ausente", @match.match_participations.find_by!(team_id: @team.id, athlete_id: @athlete.id).status
  end

  test "creates a guest match participation from the match page" do
    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    post match_match_participations_path(@match), params: {
      match_participation: {
        team_id: @team.id,
        athlete_name: "Atleta 55",
        shirt_number: "55",
        position: "Pivô",
        status: "convidado",
        notes: "Atleta fora da relação original"
      }
    }

    assert_redirected_to match_path(@match)
    participation = @match.reload.match_participations.find_by!(athlete_name: "Atleta 55")
    assert_equal "Atleta 55", participation.athlete_name
    assert_equal "55", participation.shirt_number
    assert_equal "convidado", participation.status
  end

  test "rebuilds standings when a classificatory match is saved" do
    @match.update!(
      team_a: @team,
      team_b: @team_b
    )

    patch match_path(@match), params: {
      match: {
        code: "M1",
        phase: "classificatoria",
        status: "finalizado",
        team_a_id: @team.id,
        team_b_id: @team_b.id,
        score_a: 2,
        score_b: 1
      }
    }

    assert_redirected_to match_path(@match)
    assert_equal 4, StandingRow.count
    assert_equal 3, StandingRow.find_by(team: @team).points
    assert_equal 0, StandingRow.find_by(team: @team_b).points
    assert_equal 1, StandingRow.find_by(team: @team).position
    assert_equal(-1, StandingRow.find_by(team: @team_b).goal_diff)
    assert_operator StandingRow.find_by(team: @team_b).position, :>, 1
  end

  test "advances knockout winners to the next round" do
    semi_final_1 = Match.create!(
      source_id: "match-knockout-1",
      championship: @championship,
      category: @category,
      code: "QF1",
      phase: "mata_mata",
      round_number: 1,
      team_a: @team,
      team_b: @team_b
    )

    Match.create!(
      source_id: "match-knockout-2",
      championship: @championship,
      category: @category,
      code: "QF2",
      phase: "mata_mata",
      round_number: 1,
      team_a: @team_c,
      team_b: @team_d
    )

    final_match = Match.create!(
      source_id: "match-knockout-final",
      championship: @championship,
      category: @category,
      code: "F1",
      phase: "mata_mata",
      round_number: 2
    )

    patch match_path(semi_final_1), params: {
      match: {
        score_a: 2,
        score_b: 1,
        status: "finalizado"
      }
    }

    assert_equal @team, final_match.reload.team_a

    second_semi_final = Match.find_by(source_id: "match-knockout-2")
    patch match_path(second_semi_final), params: {
      match: {
        score_a: 0,
        score_b: 1,
        status: "finalizado"
      }
    }

    assert_equal @team_d, final_match.reload.team_b
  end

  test "allows choosing a manual winner on a tied knockout match" do
    match = Match.create!(
      source_id: "match-knockout-manual-winner",
      championship: @championship,
      category: @category,
      code: "QF3",
      phase: "mata_mata",
      round_number: 1,
      team_a: @team,
      team_b: @team_b
    )

    patch match_path(match), params: {
      match: {
        score_a: 3,
        score_b: 3,
        status: "finalizado",
        winner_id: @team_b.id
      }
    }

    assert_redirected_to match_path(match)
    assert_equal @team_b, match.reload.winner
  end

  private

  def build_summula_png
    path = Rails.root.join("tmp", "summula-import-#{SecureRandom.hex(8)}.png")
    File.binwrite(path, Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO2YV2sAAAAASUVORK5CYII="))
    path.to_s
  end
end
