require "test_helper"

class Tranca::DuplasImportTest < ActiveSupport::TestCase
  setup do
    @championship = Championship.create!(source_id: "import-#{SecureRandom.uuid}", name: "Tranca", season: 2026, modality: :tranca)
    @category = @championship.ensure_tranca_onboarding_category!
  end

  test "preview does not write and import creates approved pairs with members" do
    importer = service([row("José Silva", "Ana Souza")])
    assert_no_difference ["Team.count", "Entity.count", "Athlete.count", "Tranca::Dupla.count"] do
      assert_equal "create", importer.preview.first[:action]
    end
    assert_difference "Team.count", 1 do
      assert_difference "Athlete.count", 2 do
        importer.call
      end
    end
    team = @category.teams.last
    assert team.registration_status_aprovada?
    assert team.finance_status_pendente?
    assert_equal %w[Ana\ Souza José\ Silva], team.athletes.order(:name).pluck(:name)
    mirror = @championship.tranca_duplas.find_by!(source_id: team.source_id)
    assert_equal "aprovada", mirror.registration_status
    assert_equal team.athletes.pluck(:id).sort, mirror.athletes.pluck(:id).sort
    assert_equal "Importada do Excel", team.tranca_signup_origin_label
  end

  test "reimport and reversed normalized names do not duplicate registrations" do
    service([row("José Silva", "Ana Souza")]).call
    assert_no_difference ["Team.count", "Entity.count", "Athlete.count", "Tranca::Dupla.count", "TeamAthlete.count"] do
      result = service([row(" ANA  SOUZA ", "jose silva")]).call
      assert_equal "existing", result.first[:action]
    end
  end

  test "reuses another championship's identity and athletes without moving it" do
    service([row("José Silva", "Ana Souza")]).call
    original = @category.teams.last
    original.update!(registration_status: :pendente, finance_status: :pago)
    target = Championship.create!(source_id: "target-#{SecureRandom.uuid}", name: "Outra Tranca", season: 2026, modality: :tranca)
    target_category = target.ensure_tranca_onboarding_category!
    importer = Tranca::DuplasImport.new(championship: target, category: target_category, rows: [row("Ana Souza", "José Silva")])
    assert_no_difference ["Entity.count", "Athlete.count"] do
      assert_difference "Team.count", 1 do
        assert_equal "reuse", importer.call.first[:action]
      end
    end
    team = target_category.teams.last
    assert_equal original.entity_id, team.entity_id
    assert_equal original.athletes.pluck(:id).sort, team.athletes.pluck(:id).sort
    assert_equal @category.id, original.reload.category_id
    assert original.registration_status_pendente?
    assert original.finance_status_pago?
    assert team.registration_status_aprovada?
    assert team.finance_status_pendente?
  end

  test "approves a pending local pair without changing payment" do
    service([row("Ana", "Bruno")]).call
    team = @category.teams.last
    team.update!(registration_status: :pendente, finance_status: :pago)
    assert_no_difference "Team.count" do
      assert_equal "approve", service([row("Bruno", "Ana")]).call.first[:action]
    end
    assert team.reload.registration_status_aprovada?
    assert team.finance_status_pago?
  end

  test "skips incomplete and repeated pairs and reports participant warnings" do
    result = service([row("Ana", "Bruno"), row("Bruno", "Ana", line: 3), row("Ana", "", line: 4)]).call
    assert_equal %w[create error error], result.map { |entry| entry[:action] }
    assert result.first[:warnings].any?
    assert_equal 1, @category.teams.count
  end

  test "does not guess between distinct registrations with the same participant names" do
    2.times do
      entity = Entity.create!(source_id: SecureRandom.uuid, name: "Ana / Bruno")
      Team.create!(source_id: SecureRandom.uuid, entity: entity, category: @category, name: "Ana / Bruno #{entity.id}").tap do |team|
        %w[Ana Bruno].each { |name| Athlete.create!(source_id: SecureRandom.uuid, name: name, team: team, category: @category) }
      end
    end
    # Athlete primary-link callbacks are after_commit; create the links explicitly for the transaction fixture.
    Athlete.where(category: @category).each { |athlete| athlete.send(:sync_primary_team_link) }
    assert_no_difference "Team.count" do
      assert_equal "error", service([row("Ana", "Bruno")]).call.first[:action]
    end
  end

  test "rolls back all registrations if one write fails" do
    importer = service([row("Ana", "Bruno"), row("Carlos", "Dora", line: 3)])
    original = importer.method(:register!)
    importer.define_singleton_method(:register!) do |entry|
      raise ActiveRecord::RecordInvalid.new(Team.new) if entry[:line] == 3
      original.call(entry)
    end
    assert_no_difference ["Team.count", "Entity.count", "Athlete.count", "Tranca::Dupla.count"] do
      assert_raises(ActiveRecord::RecordInvalid) { importer.call }
    end
  end

  test "rejects football and foreign categories" do
    football = Championship.create!(source_id: SecureRandom.uuid, name: "Futebol", season: 2026, modality: :football)
    assert_raises(Tranca::DuplasImport::InvalidImport) do
      Tranca::DuplasImport.new(championship: football, category: @category, rows: [row("Ana", "Bruno")])
    end
  end

  private

  def service(rows)
    Tranca::DuplasImport.new(championship: @championship, category: @category, rows: rows)
  end

  def row(first, second, line: 2)
    { "line" => line, "participant_one" => first, "participant_two" => second, "name" => "" }
  end
end
