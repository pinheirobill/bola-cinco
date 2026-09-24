module BolaCinco
  class TrancaProgramacaoPresenter
    ROW_WIDTHS = {
      jg: 28,
      mesa: 34,
      team: 235,
      pts: 28,
      center: 20
    }.freeze

    attr_reader :championship, :matches, :stage
    alias stage_filter stage

    def initialize(championship, matches, stage: "all")
      @championship = championship
      @stage = stage.presence_in(%w[all 1 2 mata_mata]) || "all"
      @matches = filter_matches(matches.to_a)
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

      grouped_matches.map do |group_key_data, group_matches|
        label = section_label_for(group_key_data, group_matches, key_index)
        key_index += 1 if label.include?("Chave")

        {
          key: section_key_for(group_key_data),
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
        .group_by { |match| grouping_key_for(match) }
        .sort_by { |(first, second), _| [ first.to_s == "Mata-mata" ? 3 : first.to_i, group_sort_key(second) ] }
    end

    def stage_label
      case stage
      when "1" then "Etapa 1"
      when "2" then "Etapa 2"
      when "mata_mata" then "Mata-mata"
      else "Todas as etapas"
      end
    end

    def row_for(match, jg_number)
      {
        match: match,
        jg: jg_number,
        code_jg: match.game_number_label,
        jg_sort: jg_number.to_i,
        mesa: mesa_label(match),
        mesa_label: mesa_display_label(match),
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

    def group_key_for_label(value, fallback_index)
      text = value.to_s.squish
      return alphabet_label(fallback_index) if text.blank? || text == "Sem chave"
      return alphabet_label(text.to_i) if text.match?(/\A\d+\z/)

      text.sub(/\ACHAVE\s+/i, "").upcase
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
      second_stage_table_number = match.source_data["table_number"] if match.second_stage?
      return second_stage_table_number.to_s if second_stage_table_number.present?

      match.tranca_mesa&.code.to_s.squish.presence || match.tranca_mesa&.name.to_s.squish.presence || match.mesa.to_s.squish.presence || "-"
    end

    def mesa_display_label(match)
      label = mesa_label(match)
      return label unless match.second_stage?

      "R#{match.round_number} · M#{label}"
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

    def filter_matches(matches)
      return matches if stage == "all"
      return matches.select(&:knockout_phase?) if stage == "mata_mata"

      stage_number = stage.to_i
      matches.select { |match| match.stage_number.to_i == stage_number && !match.knockout_phase? }
    end

    def grouping_key_for(match)
      if stage == "mata_mata"
        [ "Mata-mata", match.round_number.to_i, match.group_key.to_s.presence || "Sem chave" ]
      else
        [ match.stage_number.to_i, match.group_key.to_s.presence || "Sem chave" ]
      end
    end

    def section_label_for(group_key_data, group_matches, key_index)
      stage_label, first, second = group_key_data
      if stage_label == "Mata-mata"
        "Mata-mata · Rodada #{first}"
      elsif second == "Sem chave"
        "Etapa #{stage_label} · Sem chave"
      else
        "Etapa #{stage_label} · Chave #{group_key_for_label(second, key_index + 1)}"
      end
    end

    def section_key_for(group_key_data)
      stage_label, _, second = group_key_data
      return nil if stage_label == "Mata-mata"

      second == "Sem chave" ? nil : second
    end
  end
end
