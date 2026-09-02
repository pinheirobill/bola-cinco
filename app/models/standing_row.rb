class StandingRow < ApplicationRecord
  belongs_to :championship
  belongs_to :category
  belongs_to :team
  after_commit :sync_tranca_mirror!, on: %i[create update destroy]

  validates :position, presence: true

  def group_label
    group_key.present? ? "Chave #{group_key}" : "Geral"
  end

  def display_team
    team
  end

  def display_team_name
    team.name
  end

  private

  def sync_tranca_mirror!
    return unless championship&.tranca?

    if destroyed?
      Tranca::ClassificacaoRow.find_by(source_id: tranca_source_id)&.destroy!
      return
    end

    tranca_dupla = Tranca::Dupla.find_by(source_id: team.source_id)
    return if tranca_dupla.blank?

    tranca_row = Tranca::ClassificacaoRow.find_or_initialize_by(source_id: tranca_source_id)
    tranca_row.assign_attributes(
      championship: championship,
      category: category,
      tranca_dupla: tranca_dupla,
      group_key: group_key,
      position: position,
      played: played,
      wins: wins,
      draws: draws,
      losses: losses,
      goals_for: goals_for,
      goals_against: goals_against,
      goal_diff: goal_diff,
      points: points,
      qualified: qualified
    )
    tranca_row.save!
  end

  def tranca_source_id
    "tranca-standing-row-#{id}"
  end
end
