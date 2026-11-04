require "test_helper"

class ChampionshipSetupCategoriesTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @championship = Championship.create!(
      source_id: "champ-master-cup-template",
      name: "MASTER CUP 2026",
      season: 2026
    )
  end

  test "shows editable Master Cup suggestions without applying them automatically" do
    get setup_championship_path(@championship, step: "format")

    assert_response :success
    assert_includes response.body, "Estas são sugestões editáveis. Elas só serão criadas e vinculadas ao campeonato quando você salvar."
    assert_includes response.body, 'name="categories[0][name]"'
    %w[Pré\ Mirim Mirim Infantil Juvenil].each { |name| assert_includes response.body, "value=\"#{name}\"" }
    mode_form_end = response.body.index("</form>", response.body.index('id="championship-format-mode-form"'))
    category_form_start = response.body.index('id="category-setup-form"')
    category_form_end = response.body.index("</form>", category_form_start)
    settings_form_start = response.body.index('id="championship-format-settings-form"')
    assert_operator mode_form_end, :<, category_form_start
    assert_operator category_form_end, :<, settings_form_start
    assert_select "details#championship-default-format-settings[open]", count: 0
    assert_select "details#championship-default-format-settings > summary svg[aria-hidden='true']", count: 1
    assert_select "input[type=submit][value='Salvar categorias e continuar']", count: 1
    assert_select "a[data-turbo-confirm]", text: "Continuar sem criar categorias", count: 1
    assert_select "a.step[data-turbo-confirm]", count: 3
    assert_equal 0, @championship.categories.count
  end

  test "shows the global defaults expanded when the championship uses them as its primary format" do
    @championship.update!(name: "Copa Primavera 2026")

    get setup_championship_path(@championship, step: "format")

    assert_response :success
    assert_select "details#championship-default-format-settings[open]", count: 1
    assert_includes response.body, "Usada por categorias sem regras próprias"
  end

  test "creates categories and saves the formats selected in the form" do
    submitted_categories = {
      "0" => { name: "Pré Mirim", teamCount: 6, mode: "pontuacao", groupCount: 2, schedule: "cross_groups", matchesPerOpponent: 1, matchesPerTeam: 0 },
      "1" => { name: "Mirim", teamCount: 6, mode: "pontuacao", groupCount: 2, schedule: "cross_groups", matchesPerOpponent: 1, matchesPerTeam: 0 },
      "2" => { name: "Infantil", teamCount: 4, mode: "pontuacao", groupCount: 1, schedule: "within_groups", matchesPerOpponent: 1, matchesPerTeam: 0 },
      "3" => { name: "Juvenil", teamCount: 3, mode: "melhor_campanha_final", groupCount: 1, schedule: "within_groups", matchesPerOpponent: 1, matchesPerTeam: 0 }
    }

    assert_difference("Category.count", 4) do
      post create_categories_with_formats_championship_path(@championship), params: { categories: submitted_categories }
    end

    assert_redirected_to setup_championship_path(@championship, step: "registrations")
    formats = @championship.reload.format_data.fetch("categoryFormats")
    categories = @championship.categories.index_by(&:name)

    assert_equal 4, categories.size
    assert_equal [6, 2, "cross_groups", "pontuacao"], %w[teamCount groupCount schedule mode].map { |key| formats.fetch(categories.fetch("Pré Mirim").id.to_s).fetch(key) }
    assert_equal [6, 2, "cross_groups", "pontuacao"], %w[teamCount groupCount schedule mode].map { |key| formats.fetch(categories.fetch("Mirim").id.to_s).fetch(key) }
    assert_equal [4, 1, "within_groups", "pontuacao"], %w[teamCount groupCount schedule mode].map { |key| formats.fetch(categories.fetch("Infantil").id.to_s).fetch(key) }
    assert_equal [3, 1, "within_groups", "melhor_campanha_final"], %w[teamCount groupCount schedule mode].map { |key| formats.fetch(categories.fetch("Juvenil").id.to_s).fetch(key) }

    get setup_championship_path(@championship, step: "format")
    assert_response :success
    assert_select "details#championship-default-format-settings[open]", count: 0

    get setup_championship_path(@championship, step: "teams")
    assert_response :success
    assert_includes response.body, "Vinculadas"
    %w[Pré Mirim Mirim Infantil Juvenil].each { |name| assert_includes response.body, name }
    assert_equal 4, @championship.categories.count
  end

  test "allows a championship to use custom category names and rules" do
    assert_difference("Category.count", 1) do
      post create_categories_with_formats_championship_path(@championship), params: {
        categories: {
          "0" => { name: "Sub-13 Feminino", teamCount: 8, mode: "grupos_mata_mata", groupCount: 2, schedule: "within_groups", matchesPerOpponent: 2, matchesPerTeam: 0, qualifiedPerGroup: 2 }
        }
      }
    end

    format = @championship.reload.format_data.dig("categoryFormats", @championship.categories.sole.id.to_s)
    assert_equal [8, "grupos_mata_mata", 2, 2, "within_groups"], [format.fetch("teamCount"), format.fetch("mode"), format.fetch("groupCount"), format.fetch("matchesPerOpponent"), format.fetch("schedule")]
  end

  test "does not create categories with invalid cross-group setup" do
    assert_no_difference("Category.count") do
      post create_categories_with_formats_championship_path(@championship), params: {
        categories: {
          "0" => { name: "Sub-13", teamCount: 8, mode: "pontuacao", groupCount: 3, schedule: "cross_groups", matchesPerOpponent: 1, matchesPerTeam: 0 }
        }
      }
    end

    assert_redirected_to setup_championship_path(@championship, step: "format")
    assert_match "exatamente 2 chaves", flash[:alert]
  end

  test "creates and links an individual category from the championship setup" do
    assert_difference("Category.count", 1) do
      post create_category_championship_path(@championship), params: { category: { name: "Sub 15" } }
    end

    assert_redirected_to setup_championship_path(@championship, step: "teams")
    assert @championship.categories.exists?(name: "Sub 15")
  end
end
