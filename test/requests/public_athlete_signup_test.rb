require "test_helper"

class PublicAthleteSignupTest < ActionDispatch::IntegrationTest
  setup do
    @championship = Championship.create!(
      source_id: "champ-public-athlete-signup",
      name: "Campeonato Inscrição Atleta",
      season: 2026,
      status: :em_andamento
    )

    @category = Category.create!(
      source_id: "cat-public-athlete-signup",
      championship: @championship,
      name: "Sub 14"
    )

    @entity = Entity.create!(
      source_id: "entity-public-athlete-signup",
      name: "Clube Público"
    )

    @team = Team.create!(
      source_id: "team-public-athlete-signup",
      entity: @entity,
      category: @category,
      name: "Time Público"
    )
  end

  test "creates a public athlete signup" do
    assert_difference -> { Athlete.count }, 1 do
      post championship_athlete_signup_path(@championship), params: {
        athlete_signup: {
          team_id: @team.id,
          name: "Atleta Público",
          birth_date: "2010-02-14",
          photo_url: "https://example.com/foto.jpg",
          cpf: "123.456.789-00",
          rg: "12.345.678-9",
          birth_certificate: "CR-123",
          position: "Atacante",
          shirt_number: "9",
          cell_phone: "(11) 98888-7777",
          email: "atleta@example.com",
          passport: "BR123456",
          voter_id: "12345678901",
          gender: "Masculino",
          documents_count: 2
        }
      }
    end

    assert_response :redirect
    athlete = Athlete.find_by(name: "Atleta Público")
    assert_equal @team, athlete.team
    assert_equal @category, athlete.category
    assert_equal "123.456.789-00", athlete.cpf
  end

  test "shows validation errors for missing required fields" do
    @championship.update!(
      rules: {
        "registration" => {
          "athlete_form" => {
            "cpf" => "obrigatorio",
            "apelido" => "obrigatorio"
          }
        }
      }
    )

    post championship_athlete_signup_path(@championship), params: {
      athlete_signup: {
        team_id: @team.id,
        name: "Atleta Sem CPF"
      }
    }

    assert_response :unprocessable_entity
    assert_match(/obrigat/i, response.body)
  end

  test "returns the athlete card as pdf" do
    athlete = Athlete.create!(
      source_id: "athlete-public-athlete-pdf",
      team: @team,
      category: @category,
      name: "Atleta PDF",
      birth_date: Date.new(2010, 2, 14),
      cpf: "123.456.789-00",
      rg: "12.345.678-9",
      shirt_number: "9",
      position: "Atacante",
      registration_submitted_at: Time.current
    )

    get card_athlete_path(athlete, format: :pdf)

    assert_response :success
    assert_equal "application/pdf", response.media_type
    assert response.body.start_with?("%PDF")
  end
end
