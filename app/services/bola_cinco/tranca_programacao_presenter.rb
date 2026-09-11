module BolaCinco
  class TrancaProgramacaoPresenter
    ROW_WIDTHS = {
      jg: 28,
      mesa: 34,
      team: 235,
      pts: 28,
      center: 20
    }.freeze

    attr_reader :championship, :matches

    def initialize(championship, matches)
      @championship = championship
      @matches = matches.to_a
    end

    def title
      championship.name
    end

    def subtitle
      "Programação de jogos"
    end

    def issued_at
      Time.current
    end

    def sections
      grouped_matches.map do |group_key, group_matches|
        {
          key: group_key,
          label: group_label(group_key),
          rows: group_matches.sort_by { |match| row_sort_key(match) }.map { |match| row_for(match) }
        }
      end
    end

    def grouped_matches
      matches
        .group_by { |match| match.group_key.to_s.presence || "Sem chave" }
        .sort_by { |group_key, _| group_sort_key(group_key) }
    end

    def row_for(match)
      {
        match: match,
        jg: match.game_number_label,
        jg_sort: match.game_number_label.to_s.scan(/\d+/).first.to_i,
        mesa: mesa_label(match),
        team_a: match.dupla_a_nome.to_s.presence || "-",
        team_b: match.dupla_b_nome.to_s.presence || "-",
        score_a: score_value(match[:score_a]),
        score_b: score_value(match[:score_b]),
        key: group_label(match.group_key)
      }
    end

    def score_value(value)
      value.to_i
    end

    def group_label(value)
      text = value.to_s.squish
      text = text.sub(/\ACHAVE\s+/i, "").squish
      text.presence || "Sem chave"
    end

    def group_sort_key(group_key)
      label = group_label(group_key)
      return [ 0, label ] if label == "Sem chave"
      return [ 1, label.to_i ] if label.match?(/\A\d+\z/)

      [ 1, label.downcase ]
    end

    def mesa_label(match)
      match.tranca_mesa&.code.to_s.squish.presence || match.tranca_mesa&.name.to_s.squish.presence || match.mesa.to_s.squish.presence || "-"
    end

    def row_sort_key(match)
      [ match.game_number_label.to_s.scan(/\d+/).first.to_i, mesa_label(match).to_s.downcase, match.id.to_i ]
    end
  end
end
