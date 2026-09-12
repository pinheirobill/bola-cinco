class StandingRow < ApplicationRecord
  belongs_to :championship
  belongs_to :category
  belongs_to :team
  after_commit :sync_tranca_mirror!, on: %i[create update destroy]

  validates :position, presence: true

  def group_label
    return "Geral" if group_key.blank?

    label = group_key.to_s.squish.sub(/\ACHAVE\s+/i, "").squish
    return "Chave #{alphabet_label(label.to_i)}" if label.match?(/\A\d+\z/)

    "Chave #{label.upcase}"
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

  def alphabet_label(index)
    number = index.to_i
    return "A" if number <= 1

    letters = +""
    while number.positive?
      number, remainder = (number - 1).divmod(26)
      letters.prepend(("A".ord + remainder).chr)
    end
    letters
  end
end
