class Match < ApplicationRecord
  belongs_to :championship
  belongs_to :category
  belongs_to :team_a, class_name: "Team", optional: true
  belongs_to :team_b, class_name: "Team", optional: true
  belongs_to :winner, class_name: "Team", optional: true

  enum :status, {
    agendado: "agendado",
    em_andamento: "em_andamento",
    finalizado: "finalizado",
    wo: "wo",
    cancelado: "cancelado"
  }, prefix: true

  enum :decision, {
    normal: "normal",
    gol_de_ouro: "gol_de_ouro",
    penaltis: "penaltis"
  }, prefix: true, allow_nil: true

  validates :source_id, :code, :phase, presence: true
  validates :source_id, uniqueness: true

  def highlight_video_urls
    highlight_videos.presence || Array(source_data["highlight_videos"])
  end
end
