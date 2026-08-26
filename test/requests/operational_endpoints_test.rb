require "test_helper"

class OperationalEndpointsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user

    @championship = Championship.create!(
      source_id: "champ-req",
      name: "Campeonato Requisicao",
      season: 2026
    )
  end

  test "creates a venue" do
    post venues_path, params: {
      championship_id: @championship.id,
      venue: {
        source_id: "venue-req",
        name: "Ginásio 1"
      }
    }

    assert_response :created
    assert_equal "Ginásio 1", JSON.parse(response.body).fetch("name")
  end

  test "creates a referee" do
    post referees_path, params: {
      championship_id: @championship.id,
      referee: {
        source_id: "ref-req",
        name: "Árbitro 1"
      }
    }

    assert_response :created
    assert_equal "Árbitro 1", JSON.parse(response.body).fetch("name")
  end
end
