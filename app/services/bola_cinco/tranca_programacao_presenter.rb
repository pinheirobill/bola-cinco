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
      counter = 0
      key_index = 0

      grouped_matches.map do |group_key, group_matches|
        label = if group_key == "Sem chave"
          "Sem chave"
        else
          key_index += 1
          alphabet_label(key_index)
        end

        {
          key: group_key,
          label: label,
          rows: group_matches.sort_by { |match| row_sort_key(match) }.map do |match|
            counter += 1
            row_for(match, counter)
          end
        }
      end
    end

    def columns
      return [ sections, [] ] if sections.size <= 1

      split_index = (sections.size / 2.0).ceil
      [ sections.take(split_index), sections.drop(split_index) ]
    end

    def grouped_matches
      matches
        .group_by { |match| match.group_key.to_s.presence || "Sem chave" }
        .sort_by { |group_key, _| group_sort_key(group_key) }
    end

    def row_for(match, jg_number)
      {
        match: match,
        jg: jg_number,
        code_jg: match.game_number_label,
        jg_sort: jg_number.to_i,
        mesa: mesa_label(match),
        team_a: match.dupla_a_nome.to_s.presence || "-",
        team_b: match.dupla_b_nome.to_s.presence || "-",
        score_a: score_value(match[:score_a]),
        score_b: score_value(match[:score_b]),
        key: group_label_for(match.group_key)
      }
    end

    def score_value(value)
      value.to_i
    end

    def group_label_for(value)
      text = value.to_s.squish
      text = text.sub(/\ACHAVE\s+/i, "").squish
      return "Sem chave" if text.blank?
      return alphabet_label(text.to_i) if text.match?(/\A\d+\z/)

      text.upcase
    end

    def group_sort_key(group_key)
      label = group_key.to_s.squish
      return [ 0, label ] if label == "Sem chave"

      numeric = label.match(/\A(?:CHAVE\s+)?(\d+)\z/i)
      return [ 1, numeric[1].to_i ] if numeric

      letter = label.match(/\A(?:CHAVE\s+)?([A-Z]+)\z/i)
      return [ 2, letter[1].upcase ] if letter

      [ 3, label.downcase ]
    end

    def mesa_label(match)
      match.tranca_mesa&.code.to_s.squish.presence || match.tranca_mesa&.name.to_s.squish.presence || match.mesa.to_s.squish.presence || "-"
    end

    def row_sort_key(match)
      [ match.game_number_label.to_s.scan(/\d+/).first.to_i, mesa_label(match).to_s.downcase, match.id.to_i ]
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
end
