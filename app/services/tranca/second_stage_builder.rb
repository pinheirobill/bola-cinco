module Tranca
  class SecondStageBuilder
    class InvalidSelectionError < StandardError; end

    STAGE_NUMBER = 2
    GROUP_SIZE = 4
    ROUND_PAIRINGS = {
      1 => [[0, 1], [3, 2]],
      2 => [[3, 0], [2, 1]],
      3 => [[0, 2], [1, 3]]
    }.freeze

    attr_reader :championship

    def initialize(championship)
      @championship = championship
    end

    def create!(groups:)
      normalized_groups = normalize_groups(groups)
      duplas_by_id = validate_selection!(normalized_groups)

      championship.with_lock do
        if championship.tranca_rodadas.for_stage(STAGE_NUMBER).exists? || championship.tranca_partidas.for_stage(STAGE_NUMBER).exists?
          raise InvalidSelectionError, "A 2ª etapa já foi criada para este campeonato."
        end

        ROUND_PAIRINGS.each_key.map do |round_number|
          create_round!(round_number, normalized_groups, duplas_by_id)
        end
      end
    end

    private

    def normalize_groups(groups)
      raw_groups = if groups.respond_to?(:to_unsafe_h)
        groups.to_unsafe_h
      else
        groups.to_h
      end

      raw_groups.keys.map(&:to_s).reject(&:blank?).uniq.sort.to_h do |group_key|
        ids = Array(raw_groups[group_key] || raw_groups[group_key.to_sym])
          .filter_map { |id| Integer(id, exception: false) }
        [group_key, ids]
      end
    end

    def validate_selection!(groups)
      group_keys = groups.keys
      raise InvalidSelectionError, "Crie pelo menos uma chave." if group_keys.empty?

      invalid_group = group_keys.find { |group_key| groups.fetch(group_key).size != GROUP_SIZE }
      if invalid_group
        raise InvalidSelectionError, "A chave #{invalid_group} precisa ter exatamente #{GROUP_SIZE} duplas."
      end

      selected_ids = group_keys.flat_map { |group_key| groups.fetch(group_key) }
      if selected_ids.uniq.size != selected_ids.size
        raise InvalidSelectionError, "A mesma dupla não pode aparecer em mais de uma posição da 2ª etapa."
      end

      duplas_by_id = championship.tranca_duplas.where(id: selected_ids).index_by(&:id)
      if duplas_by_id.size != selected_ids.size
        raise InvalidSelectionError, "Selecione apenas duplas deste campeonato."
      end

      category_ids = duplas_by_id.values.map(&:category_id).uniq
      if category_ids.size != 1
        raise InvalidSelectionError, "As 16 duplas da 2ª etapa precisam pertencer à mesma categoria."
      end

      duplas_by_id
    end

    def create_round!(round_number, groups, duplas_by_id)
      rodada = championship.tranca_rodadas.create!(
        stage_number: STAGE_NUMBER,
        phase: "classificatoria",
        round_number: round_number,
        source_id: "tranca-stage-2-round-#{championship.id}-#{round_number}",
        label: "2ª etapa · Rodada #{round_number}",
        status: "programada"
      )

      groups.keys.each_with_index do |group_key, group_index|
        group_ids = groups.fetch(group_key)

        ROUND_PAIRINGS.fetch(round_number).each_with_index do |(first_slot, second_slot), pairing_index|
          table_number = (group_index * 2) + pairing_index + 1
          create_match!(
            rodada: rodada,
            round_number: round_number,
            group_key: group_key,
            table_number: table_number,
            dupla_a: duplas_by_id.fetch(group_ids.fetch(first_slot)),
            dupla_b: duplas_by_id.fetch(group_ids.fetch(second_slot)),
            first_slot: first_slot + 1,
            second_slot: second_slot + 1
          )
        end
      end

      rodada
    end

    def create_match!(rodada:, round_number:, group_key:, table_number:, dupla_a:, dupla_b:, first_slot:, second_slot:)
      mesa = championship.tranca_mesas.create!(
        tranca_rodada: rodada,
        source_id: "tranca-stage-2-table-#{championship.id}-#{round_number}-#{table_number}",
        code: "E2-R#{round_number}-M#{table_number}",
        name: "Mesa #{table_number}",
        status: "disponivel"
      )

      championship.tranca_partidas.create!(
        category: dupla_a.category,
        tranca_rodada: rodada,
        tranca_mesa: mesa,
        dupla_a: dupla_a,
        dupla_b: dupla_b,
        stage_number: STAGE_NUMBER,
        source_id: "tranca-stage-2-match-#{championship.id}-#{round_number}-#{table_number}",
        code: "E2-R#{round_number}-J#{table_number}",
        phase: "classificatoria",
        round_number: round_number,
        group_key: group_key,
        status: :agendado,
        source_data: {
          "generated_by" => "tranca_second_stage_builder",
          "kind" => "second_stage_group",
          "group_key" => group_key,
          "table_number" => table_number,
          "slot_a" => first_slot,
          "slot_b" => second_slot
        }
      )
    end
  end
end
