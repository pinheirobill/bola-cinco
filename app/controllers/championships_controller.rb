require "base64"
require "fileutils"

class ChampionshipsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @championships = if user_signed_in?
      current_user.admin? ? Championship.order(season: :desc, created_at: :desc).includes(:categories) : current_user.accessible_championships.order(season: :desc, created_at: :desc).includes(:categories)
    else
      Championship.publicly_visible.order(season: :desc, created_at: :desc).includes(:categories)
    end
  end

  def new
    return forbidden! unless current_user&.admin?

    @championship = Championship.new
    @championship.season ||= Time.zone.today.year
    @championship.status ||= :rascunho
  end

  def create
    return forbidden! unless current_user&.admin?

    @championship = Championship.new(championship_params)
    @championship.status = :rascunho

    if @championship.save
      set_current_championship(@championship)
      redirect_to setup_championship_path(@championship, step: "data"), notice: "Campeonato criado."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @championship = championship_lookup
    return forbidden! unless @championship.visible_by?(current_user) || @championship.publicly_visible? || current_user&.admin?

    load_championship_overview
    load_tranca_overview if @championship.tranca?
    render("championships/tranca_show") if @championship.tranca?
  end

  def duplas
    @championship = championship_lookup
    return forbidden! unless @championship.visible_by?(current_user) || @championship.publicly_visible? || current_user&.admin?
    return redirect_to championship_path(@championship), alert: "Essa visão é específica da Tranca." unless @championship.tranca?

    load_tranca_duplas
    render "championships/tranca_duplas"
  end

  def partidas
    @championship = championship_lookup
    return forbidden! unless @championship.visible_by?(current_user) || @championship.publicly_visible? || current_user&.admin?
    return redirect_to championship_path(@championship), alert: "Essa visão é específica da Tranca." unless @championship.tranca?

    load_tranca_management
    render "championships/tranca_partidas"
  end

  def rodadas
    @championship = championship_lookup
    return forbidden! unless @championship.visible_by?(current_user) || @championship.publicly_visible? || current_user&.admin?
    return redirect_to championship_path(@championship), alert: "Essa visão é específica da Tranca." unless @championship.tranca?

    load_tranca_management
    render "championships/tranca_rodadas"
  end

  def programacao
    @championship = championship_lookup
    return forbidden! unless @championship.visible_by?(current_user) || @championship.publicly_visible? || current_user&.admin?
    return redirect_to championship_path(@championship), alert: "Essa visão é específica da Tranca." unless @championship.tranca?

    load_tranca_programacao
    @tranca_programacao = BolaCinco::TrancaProgramacaoPresenter.new(@championship, @tranca_partidas)

    respond_to do |format|
      format.html { render "championships/tranca_programacao" }
      format.pdf do
        pdf = BolaCinco::TrancaProgramacaoDocument.new(@tranca_programacao).render
        send_data pdf, filename: "#{@championship.name.parameterize}-programacao.pdf",
          type: "application/pdf", disposition: "attachment"
      end
    end
  end

  def programacao_telao
    @championship = championship_lookup
    return forbidden! unless @championship.visible_by?(current_user) || @championship.publicly_visible? || current_user&.admin?
    return redirect_to championship_path(@championship), alert: "Essa visão é específica da Tranca." unless @championship.tranca?

    load_tranca_programacao
    @tranca_programacao = BolaCinco::TrancaProgramacaoPresenter.new(@championship, @tranca_partidas)
    render "championships/tranca_programacao_telao", layout: "telao"
  end

  def classificacao
    @championship = championship_lookup
    return forbidden! unless @championship.visible_by?(current_user) || @championship.publicly_visible? || current_user&.admin?
    return redirect_to championship_path(@championship), alert: "Essa visão é específica da Tranca." unless @championship.tranca?

    load_tranca_management
    respond_to do |format|
      format.html { render "championships/tranca_classificacao" }
      format.pdf do
        duplas = @championship.tranca_duplas.includes(:category, :athletes).order(:name)
        pdf = BolaCinco::TrancaStandingsDocument.new(
          @championship, groups: @tranca_standing_groups, duplas: duplas
        ).render
        send_data pdf, filename: "#{@championship.name.parameterize}-classificacao-participantes.pdf",
          type: "application/pdf", disposition: "attachment"
      end
    end
  end

  def generate_tranca_round
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_back fallback_location: rodadas_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?

    phase = params[:phase].presence_in(%w[classificatoria mata_mata]) || "classificatoria"
    round_number = params[:round_number].presence&.to_i
    round_number = next_tranca_round_number(phase) if round_number.blank? || round_number <= 0

    flow = Tranca::CompetitionFlow.new(@championship)
    rodada = flow.generate_round!(phase: phase, round_number: round_number)

    redirect_back fallback_location: rodadas_championship_path(@championship), notice: "#{rodada.label} gerada."
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: rodadas_championship_path(@championship), alert: "Categoria inválida."
  rescue ActiveRecord::RecordInvalid => e
    redirect_back fallback_location: rodadas_championship_path(@championship), alert: e.record.errors.full_messages.join(" · ")
  rescue Tranca::CompetitionFlow::InvalidScheduleError => error
    redirect_back fallback_location: rodadas_championship_path(@championship), alert: error.message, status: :see_other
  rescue Tranca::CompetitionFlow::NoAvailableMatchupsError
    redirect_back fallback_location: rodadas_championship_path(@championship), alert: "Não há mais confrontos diferentes disponíveis: todas as duplas já jogaram entre si."
  rescue Tranca::CompetitionFlow::InvalidKnockoutSelectionError => error
    redirect_back fallback_location: classificacao_championship_path(@championship), alert: error.message, status: :see_other
  end

  def select_tranca_knockout_duplas
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_back fallback_location: classificacao_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?

    Tranca::CompetitionFlow.new(@championship).generate_knockout_round!(
      round_number: 1,
      selected_dupla_ids: params[:dupla_ids]
    )

    redirect_to rodadas_championship_path(@championship), notice: "Chave eliminatória gerada com 16 duplas."
  rescue Tranca::CompetitionFlow::InvalidKnockoutSelectionError => error
    redirect_back fallback_location: classificacao_championship_path(@championship), alert: error.message, status: :see_other
  rescue ActiveRecord::RecordInvalid => error
    redirect_back fallback_location: classificacao_championship_path(@championship), alert: error.record.errors.full_messages.join(" · ")
  end

  def generate_tranca_mesas
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_back fallback_location: rodadas_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?

    rodada = @championship.tranca_rodadas.find(params[:rodada_id])
    Tranca::CompetitionFlow.new(@championship).assign_mesas!(rodada)

    redirect_back fallback_location: rodadas_championship_path(@championship), notice: "Mesas da #{rodada.label} definidas."
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: rodadas_championship_path(@championship), alert: "Rodada inválida."
  end

  def destroy_tranca_round
    fallback_location = rodadas_championship_path(params[:id])
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_back fallback_location: rodadas_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?

    rodada = @championship.tranca_rodadas.find(params[:rodada_id])
    round_label = rodada.label
    redirect_back(fallback_location: fallback_location, alert: "Não é possível excluir uma rodada com jogo finalizado.") and return unless rodada.deletable?

    Tranca::Rodada.transaction do
      rodada.partidas.destroy_all
      rodada.mesas.destroy_all
      rodada.destroy!
      Tranca::CompetitionFlow.new(@championship).rebuild_classificacao! if rodada.classificatoria?
    end

    redirect_back fallback_location: fallback_location, notice: "#{round_label} excluída."
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: fallback_location, alert: "Rodada inválida."
  end

  def destroy_tranca_key
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_back fallback_location: rodadas_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?
    destroy_tranca_key_with_fallback(rodadas_championship_path(@championship))
  end

  def destroy_tranca_programacao_key
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_back fallback_location: programacao_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?
    destroy_tranca_key_with_fallback(programacao_championship_path(@championship))
  end

  def update_tranca_classificacao_row
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_back fallback_location: classificacao_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?

    row = @championship.tranca_classificacao_rows.find(params[:row_id])
    dupla = @championship.tranca_duplas.find(params.fetch(:tranca_classificacao_row, {}).fetch(:tranca_dupla_id))

    return redirect_back fallback_location: classificacao_championship_path(@championship), alert: "A dupla precisa ser da mesma categoria da chave." unless dupla.category_id == row.category_id

    if @championship.tranca_classificacao_rows.where(category_id: row.category_id, group_key: row.group_key, tranca_dupla_id: dupla.id).where.not(id: row.id).exists?
      return redirect_back fallback_location: classificacao_championship_path(@championship), alert: "Essa dupla já está nesta chave."
    end

    row.update!(tranca_dupla: dupla)
    redirect_back fallback_location: classificacao_championship_path(@championship), notice: "Dupla da chave atualizada."
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: classificacao_championship_path(@championship), alert: "Linha de classificação inválida."
  end

  def replace_tranca_classificacao_row_from_recent_team
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_back fallback_location: classificacao_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?

    row = @championship.tranca_classificacao_rows.find(params[:row_id])
    team = recent_tranca_source_teams.find { |candidate| candidate.id == params[:team_id].to_i }
    return redirect_back fallback_location: classificacao_championship_path(@championship), alert: "Dupla recente inválida." if team.blank?

    dupla = @championship.invite_tranca_dupla_into_category!(team, row.category)
    return redirect_back fallback_location: classificacao_championship_path(@championship), alert: "Não foi possível criar a dupla para esta chave." if dupla.blank?

    if @championship.tranca_classificacao_rows.where(category_id: row.category_id, group_key: row.group_key, tranca_dupla_id: dupla.id).where.not(id: row.id).exists?
      return redirect_back fallback_location: classificacao_championship_path(@championship), alert: "Essa dupla já está nesta chave."
    end

    row.update!(tranca_dupla: dupla)
    redirect_back fallback_location: classificacao_championship_path(@championship), notice: "Dupla recente adicionada à chave."
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: classificacao_championship_path(@championship), alert: "Linha de classificação inválida."
  end

  def destroy_tranca_classificacao_row
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_back fallback_location: classificacao_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?

    row = @championship.tranca_classificacao_rows.find(params[:row_id])
    group_key = row.group_key.to_s
    row_position = row.position.to_i

    Tranca::ClassificacaoRow.transaction do
      row.destroy!
      @championship.tranca_classificacao_rows
        .where(category_id: row.category_id, group_key: group_key)
        .where("position > ?", row_position)
        .order(:position)
        .find_each do |remaining_row|
          remaining_row.update_columns(position: remaining_row.position - 1, updated_at: Time.current)
        end
    end

    redirect_back fallback_location: classificacao_championship_path(@championship), notice: "Linha removida da chave."
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: classificacao_championship_path(@championship), alert: "Linha de classificação inválida."
  end

  def update_tranca_partida
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_back fallback_location: partidas_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?

    partida = @championship.tranca_partidas.find(params[:partida_id])
    params_data = params.fetch(:tranca_partida, {}).permit(
      :dupla_a_id,
      :dupla_b_id,
      :score_a,
      :score_b,
      :status,
      :winner_id,
      :decision,
      :wo,
      maos_attributes: [
        :source_id,
        :numero,
        :pontos_a,
        :pontos_b,
        :canastra_limpa_a,
        :canastra_limpa_b,
        :canastra_suja_a,
        :canastra_suja_b,
        :batida_a,
        :batida_b,
        :tres_vermelho_a,
        :tres_vermelho_b,
        :desconto_a,
        :desconto_b,
        :observacoes
      ]
    )

    if params_data[:dupla_a_id].present? || params_data[:dupla_b_id].present?
      duplas_update = params_data[:dupla_a_id].present? && params_data[:dupla_b_id].present?

      if duplas_update && params_data[:score_a].blank? && params_data[:score_b].blank? && params_data[:winner_id].blank? && params_data[:decision].blank? && params_data[:wo].blank? && params_data[:maos_attributes].blank?
        return redirect_back fallback_location: rodadas_championship_path(@championship), alert: "Só é possível alterar a dupla em partidas agendadas." unless partida.status_agendado?

        dupla_a = @championship.tranca_duplas.find(params_data[:dupla_a_id])
        dupla_b = @championship.tranca_duplas.find(params_data[:dupla_b_id])
        return redirect_back fallback_location: rodadas_championship_path(@championship), alert: "As duplas precisam ser da mesma categoria da partida." unless dupla_a.category_id == partida.category_id && dupla_b.category_id == partida.category_id
        return redirect_back fallback_location: rodadas_championship_path(@championship), alert: "A mesma dupla não pode ocupar os dois lados do jogo." if dupla_a.id == dupla_b.id

        partida.update!(dupla_a: dupla_a, dupla_b: dupla_b)

        return redirect_back fallback_location: rodadas_championship_path(@championship), notice: "Duplas da partida atualizadas."
      end

      if duplas_update
        dupla_a = @championship.tranca_duplas.find(params_data[:dupla_a_id])
        dupla_b = @championship.tranca_duplas.find(params_data[:dupla_b_id])
        return redirect_back fallback_location: rodadas_championship_path(@championship), alert: "As duplas precisam ser da mesma categoria da partida." unless dupla_a.category_id == partida.category_id && dupla_b.category_id == partida.category_id
        return redirect_back fallback_location: rodadas_championship_path(@championship), alert: "A mesma dupla não pode ocupar os dois lados do jogo." if dupla_a.id == dupla_b.id

        partida.assign_attributes(
          dupla_a: dupla_a,
          dupla_b: dupla_b
        )
        partida.save!
      end
    end

    Tranca::CompetitionFlow.new(@championship).record_result!(
      partida: partida,
      score_a: params_data[:score_a].presence,
      score_b: params_data[:score_b].presence,
      status: params_data[:status].presence || partida.status,
      winner_id: params_data[:winner_id].presence,
      decision: params_data[:decision].presence,
      wo: params_data[:wo].presence,
      maos_attributes: normalize_tranca_maos_attributes(params_data[:maos_attributes])
    )

    redirect_back fallback_location: partidas_championship_path(@championship), notice: "Resultado lançado."
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: partidas_championship_path(@championship), alert: "Partida inválida."
  rescue ActiveRecord::RecordInvalid => e
    redirect_back fallback_location: partidas_championship_path(@championship), alert: e.record.errors.full_messages.join(" · ")
  end

  def destroy_tranca_partida
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_back fallback_location: rodadas_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?

    partida = @championship.tranca_partidas.find(params[:partida_id])
    return redirect_back fallback_location: rodadas_championship_path(@championship), alert: "Só é possível excluir partidas agendadas." unless partida.status_agendado?

    rodada = partida.tranca_rodada
    mesa = partida.tranca_mesa
    partida_label = "#{partida.code} · #{partida.category.name}"

    Tranca::Partida.transaction do
      partida.destroy!
      mesa.destroy! if mesa.present? && mesa.partidas.reload.empty?
      Tranca::CompetitionFlow.new(@championship).rebuild_classificacao! if rodada&.classificatoria?
    end

    redirect_back fallback_location: rodadas_championship_path(@championship), notice: "#{partida_label} excluída."
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: rodadas_championship_path(@championship), alert: "Partida inválida."
  end

  def download_tranca_summula
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user) || @championship.visible_by?(current_user) || @championship.publicly_visible? || current_user&.admin?
    return redirect_back fallback_location: partidas_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?

    partida = @championship.tranca_partidas.find(params[:partida_id])
    pdf = BolaCinco::TrancaSummulaDocument.new(partida).render
    send_data pdf, filename: tranca_summula_filename(partida), type: "application/pdf", disposition: "attachment"
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: partidas_championship_path(@championship), alert: "Partida inválida."
  end

  def download_complete_tranca_summula
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user) || @championship.visible_by?(current_user) || @championship.publicly_visible? || current_user&.admin?
    return redirect_back fallback_location: partidas_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?

    partida = @championship.tranca_partidas.find(params[:partida_id])
    pdf = BolaCinco::TrancaSummulaDocument.new(partida, filled: true).render
    send_data pdf, filename: tranca_complete_summula_filename(partida), type: "application/pdf", disposition: "attachment"
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: partidas_championship_path(@championship), alert: "Partida inválida."
  end

  def import_tranca_summula
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_back fallback_location: partidas_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?

    @partida = @championship.tranca_partidas.find(params[:partida_id])

    if params.dig(:tranca_summula_import, :confirm).present?
      confirm_tranca_summula_import
    elsif request.get?
      @import_preview = nil
      render :import_tranca_summula
    else
      build_tranca_summula_import_preview
    end
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: partidas_championship_path(@championship), alert: "Partida inválida."
  end

  def rebuild_tranca_classificacao
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_back fallback_location: classificacao_championship_path(@championship), alert: "Essa ação é específica da Tranca." unless @championship.tranca?

    Tranca::CompetitionFlow.new(@championship).rebuild_classificacao!
    redirect_back fallback_location: classificacao_championship_path(@championship), notice: "Classificação recalculada."
  end

  def setup
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    load_championship_setup
  end

  def update
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    Rails.logger.info(
      "[championships#update] id=#{@championship.id} autosave=#{autosave_request?} " \
      "step=#{params[:step].presence || params[:current_step].presence || 'data'} format=#{(params.dig(:championship, :format)&.to_unsafe_h || {}).inspect} " \
      "scoring=#{(params.dig(:championship, :scoring)&.to_unsafe_h || {}).inspect}"
    )

    if @championship.update(championship_params)
      Rails.logger.info(
        "[championships#update] persisted id=#{@championship.id} " \
        "format=#{@championship.format.inspect} scoring=#{@championship.scoring.inspect}"
      )

      return head :no_content if autosave_request?

      redirect_to setup_championship_path(@championship, step: params[:step].presence || params[:current_step].presence || "data"), notice: "Campeonato atualizado."
    else
      Rails.logger.warn(
        "[championships#update] failed id=#{@championship.id} errors=#{@championship.errors.full_messages.join(' | ')} " \
        "format=#{@championship.format.inspect} scoring=#{@championship.scoring.inspect}"
      )

      load_championship_setup
      @step = params[:step].presence_in(%w[data format registrations teams publish]) || params[:current_step].presence_in(%w[data format registrations teams publish]) || "data"
      return head :unprocessable_entity if autosave_request?

      render :setup, status: :unprocessable_entity
    end
  end

  def finalize_onboarding
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    @championship.ensure_tranca_onboarding_category! if @championship.tranca?
    @championship.update!(status: :em_andamento)
    redirect_back fallback_location: championship_path(@championship), notice: "Onboarding concluído."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to setup_championship_path(@championship, step: "publish"), alert: e.record.errors.full_messages.join(" · ")
  end

  def finalize_registrations
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    created_matches = @championship.finalize_registrations!

    redirect_to championship_path(@championship), notice: "Inscrições finalizadas. #{created_matches.size} jogos gerados."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to championship_path(@championship), alert: e.record.errors.full_messages.join(" · ")
  end

  def draw_knockout_round
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_to setup_championship_path(@championship, step: "teams"), alert: "O sorteio inicial só está disponível em mata-mata." unless @championship.format_data["mode"].to_s == "mata_mata"

    created_matches = @championship.draw_initial_knockout_round!
    redirect_to setup_championship_path(@championship, step: "teams"), notice: "#{created_matches.size} jogos da primeira rodada sorteados."
  end

  def attach_category
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    category = Category.find(params[:category_id])
    @championship.categories << category unless @championship.categories.exists?(category.id)

    redirect_to setup_championship_path(@championship, step: "teams"), notice: "Categoria vinculada ao campeonato."
  rescue ActiveRecord::RecordNotFound
    redirect_to setup_championship_path(@championship, step: "teams"), alert: "Categoria inválida."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to setup_championship_path(@championship, step: "teams"), alert: e.record.errors.full_messages.join(" · ")
  end

  def detach_category
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    category = @championship.categories.find(params[:category_id])
    @championship.championship_categories.find_by!(category_id: category.id).destroy!

    redirect_to setup_championship_path(@championship, step: "teams"), notice: "Categoria removida do campeonato."
  rescue ActiveRecord::RecordNotFound
    redirect_to setup_championship_path(@championship, step: "teams"), alert: "Categoria inválida."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to setup_championship_path(@championship, step: "teams"), alert: e.record.errors.full_messages.join(" · ")
  end

  def attach_team
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    category = @championship.categories.find(params[:category_id])
    team_ids = Array(params[:team_ids].presence || params[:team_id]).compact_blank.map(&:to_s)
    raise ActiveRecord::RecordNotFound, "Equipe inválida" if team_ids.blank?

    available_teams = Team.includes(:entity, :category).where.not(category_id: @championship.categories.select(:id))
    teams = available_teams.where(id: team_ids).to_a
    raise ActiveRecord::RecordNotFound, "Equipe inválida" if teams.size != team_ids.size

    Team.transaction do
      teams.each do |team|
        team.update!(
          category: category,
          registration_status: (@championship.tranca? ? :pendente : team.registration_status)
        )
      end
    end

    redirect_to setup_championship_path(@championship, step: "teams"), notice: "#{teams.size} equipes vinculadas à categoria #{category.name}."
  rescue ActiveRecord::RecordNotFound
    redirect_to setup_championship_path(@championship, step: "teams"), alert: "Equipe ou categoria inválida."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to setup_championship_path(@championship, step: "teams"), alert: e.record.errors.full_messages.join(" · ")
  end

  def invite_recent_tranca_duplas
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_to setup_championship_path(@championship, step: "teams"), alert: "Essa ação é específica da Tranca." unless @championship.tranca?

    team_ids = Array(params[:team_ids]).compact_blank.map(&:to_s)
    return redirect_to setup_championship_path(@championship, step: "teams"), alert: "Selecione ao menos uma dupla para convidar." if team_ids.blank?

    recent_teams = recent_tranca_source_teams
    teams_to_invite = recent_teams.select { |team| team_ids.include?(team.id.to_s) }
    return redirect_to setup_championship_path(@championship, step: "teams"), alert: "As duplas selecionadas não estão disponíveis para convite." if teams_to_invite.blank?

    invited_count = @championship.invite_selected_tranca_duplas!(teams_to_invite)
    category = @championship.ensure_tranca_onboarding_category!

    notice = if invited_count.positive?
      "#{invited_count} duplas convidadas para a categoria #{category.name}."
    else
      "Nenhuma dupla recente encontrada para convidar."
    end

    redirect_to setup_championship_path(@championship, step: "teams"), notice: notice
  rescue ActiveRecord::RecordInvalid => e
    redirect_to setup_championship_path(@championship, step: "teams"), alert: e.record.errors.full_messages.join(" · ")
  end

  def confirm_all_team_registrations
    @championship = championship_lookup
    return forbidden! unless current_user&.admin?

    pending_teams = @championship.categories.includes(:teams).flat_map(&:teams).select(&:registration_status_pendente?)
    pending_teams.each(&:approve!)

    redirect_back fallback_location: championship_path(@championship), notice: "#{pending_teams.size} inscrições confirmadas."
  end

  def attach_partner
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    source_partner = Partner.find(params[:partner_id])
    record = @championship.partners.new(
      category: source_partner.category,
      name: source_partner.name,
      tier: source_partner.tier,
      status: :ativo,
      logo_url: source_partner.logo_url,
      website_url: source_partner.website_url,
      highlight: true,
      notes: source_partner.notes,
      source_data: source_partner.source_data.deep_dup
    )
    record.source_id = "partner-#{SecureRandom.hex(4)}"
    record.save!

    redirect_back fallback_location: championship_path(@championship), notice: "Parceiro adicionado ao campeonato."
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: championship_path(@championship), alert: "Parceiro inválido."
  rescue ActiveRecord::RecordInvalid => e
    redirect_back fallback_location: championship_path(@championship), alert: e.record.errors.full_messages.join(" · ")
  end

  private

  def destroy_tranca_key_with_fallback(fallback_location)
    rodada = @championship.tranca_rodadas.find_by(id: params[:rodada_id]) if params[:rodada_id].present?
    group_key = params[:group_key].to_s.squish
    partidas = if rodada.present?
      rodada.partidas.where(group_key: group_key)
    else
      @championship.tranca_partidas.where(group_key: group_key)
    end

    return redirect_back fallback_location: fallback_location, alert: "Chave inválida." if group_key.blank? || partidas.blank?
    return redirect_back fallback_location: fallback_location, alert: "Só é possível excluir chaves com jogos agendados." if partidas.where.not(status: :agendado).exists?

    key_label = group_key.sub(/\ACHAVE\s+/i, "").presence || group_key

    Tranca::Rodada.transaction do
      mesas = partidas.includes(:tranca_mesa).map(&:tranca_mesa).compact.uniq

      partidas.to_a.each(&:destroy!)

      mesas.each do |mesa|
        mesa.destroy! if mesa.partidas.reload.empty?
      end

      Tranca::CompetitionFlow.new(@championship).rebuild_classificacao! if rodada&.classificatoria?

      if rodada.present? && rodada.partidas.reload.empty?
        rodada.mesas.destroy_all
        rodada.destroy!
      end
    end

    redirect_back fallback_location: fallback_location, notice: "Chave #{key_label} excluída."
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: fallback_location, alert: "Chave inválida."
  end

  def championship_lookup
    identifier = params[:id].to_s
    legacy_id = identifier[/\A(\d+)-/, 1]

    Championship.find_by(slug: identifier) ||
      Championship.find_by(id: identifier) ||
      Championship.find_by(id: legacy_id) ||
      Championship.find(identifier)
  end

  def load_championship_overview
    @championship = Championship.includes(
      categories: %i[teams championships],
      matches: %i[team_a team_b winner],
      standing_rows: :team,
      partners: :category
    ).find(@championship.id)
    @available_teams = if @championship.tranca?
      Team.for_championship(@championship).includes(:entity, :category).order(:name)
    else
      Team.includes(:entity, :category).order(:name)
    end
    @recent_matches = @championship.recent_matches(8)
    @top_scorers = @championship.top_scorers(5)
    @best_defense_row = @championship.best_defense_row
    @worst_defense_row = @championship.worst_defense_row
    @top_athletes = @championship.top_athletes(5)
    @featured_partners = @championship.featured_partners(5)
    @championship_partners = @championship.partners.includes(:category).order(highlight: :desc, tier: :asc, created_at: :desc)
    @available_partners_to_link = Partner.includes(:championship, :category).where.not(championship_id: @championship.id).status_ativo.order(:name)
    @standing_groups = @championship.standing_groups
    @knockout_brackets = build_knockout_brackets(@championship)
  end

  def load_tranca_overview
    load_tranca_management
    @tranca_round_label = @tranca_rodadas.first&.label || "Rodada inicial"
    @tranca_recent_duplas = @championship.tranca_duplas.includes(:entity, :category).order(created_at: :desc).limit(3)
    @tranca_signed_up_dupla = params[:signup_team].present? ? @championship.tranca_duplas.includes(:entity, :category).find_by(source_id: params[:signup_team]) : nil
  end

  def load_championship_setup
    @championship = Championship.includes(categories: %i[teams championships]).find(@championship.id)
    @step = params[:step].presence_in(%w[data format registrations teams publish]) || "data"
    if @championship.tranca? && @step == "teams"
      @tranca_onboarding_category = @championship.ensure_tranca_onboarding_category!
      @recent_tranca_championships = @championship.recent_tranca_championships
      @recent_tranca_source_teams = recent_tranca_source_teams
      @championship = @championship.reload
    end
    @available_teams_by_category = Team.includes(:entity, :category).where(category: @championship.categories).order(:name).group_by(&:category_id)
    @available_teams_to_link = Team.includes(:entity, :category).where.not(category_id: @championship.categories.select(:id)).order(:name)
    @championship_categories = @championship.categories.includes(:championships, :teams).order(:name)
    @available_categories_to_link = Category.includes(:championships, :teams).where.not(id: @championship.categories.select(:id)).order(:name)
    @highlight_category_id = params[:highlight_category_id].presence&.to_i
    if @highlight_category_id.present?
      @available_categories_to_link = @available_categories_to_link.sort_by { |category| [ category.id == @highlight_category_id ? 0 : 1, category.name.to_s.downcase ] }
    end
    @venues = @championship.venues.order(:name)
    @referees = @championship.referees.order(:name)
    @available_venues = Venue.available.order(:name)
    @available_referees = Referee.available.order(:name)
    @recent_matches = @championship.recent_matches(8)
    @top_scorers = @championship.top_scorers(5)
    @best_defense_row = @championship.best_defense_row
    @worst_defense_row = @championship.worst_defense_row
    @top_athletes = @championship.top_athletes(5)
    @featured_partners = @championship.featured_partners(5)
    @standing_groups = @championship.standing_groups
    @initial_knockout_matches = @championship.matches.includes(:category, :team_a, :team_b).where(phase: "mata_mata", round_number: 1).order(:category_id, :id)
    @initial_knockout_matches_by_category = @initial_knockout_matches.group_by(&:category)
  end

  def load_tranca_duplas
    @tranca_categories = @championship.categories.order(:name).to_a
    @tranca_default_category = @tranca_categories.first
    @tranca_entities = Entity.order(:name)
    @tranca_duplas = @championship.tranca_duplas.includes(:entity, :athletes).order(:name).to_a
    @tranca_duplas_by_category = @tranca_duplas.group_by(&:category_id)
    @tranca_total_duplas = @tranca_duplas.size
    @tranca_total_partidas = @championship.tranca_partidas.count
    @tranca_legacy_teams = Team.where(source_id: @tranca_duplas.map(&:source_id)).index_by(&:source_id)
  end

  def load_tranca_management
    if @championship.tranca_classificacao_rows.none? && @championship.tranca_partidas.where(phase: "classificatoria").exists?
      Tranca::CompetitionFlow.new(@championship).rebuild_classificacao!
    end
    dashboard = Tranca::Dashboard.new(@championship)
    @championship = dashboard.championship
    @tranca_dashboard = dashboard
    @tranca_categories = dashboard.categories
    @tranca_default_category = @tranca_categories.first
    @tranca_entities = dashboard.entities
    @tranca_duplas = dashboard.duplas
    @tranca_duplas_by_category = dashboard.duplas_by_category
    @tranca_partidas = dashboard.partidas
    @tranca_rodadas = dashboard.rodadas
    @tranca_live_matches = dashboard.live_partidas
    @tranca_recent_results = dashboard.recent_results
    @tranca_upcoming_matches = dashboard.upcoming_partidas
    @tranca_standing_groups = dashboard.standings_groups
    @tranca_standings = dashboard.classificacao_rows
    @tranca_total_duplas = dashboard.total_duplas
    @tranca_admin_teams = Team.for_championship(@championship).includes(:entity, :category).order(created_at: :desc)
    @tranca_total_partidas = dashboard.total_partidas
    @tranca_total_rodadas = dashboard.total_rodadas
    @tranca_total_classificados = dashboard.total_classificados
    @tranca_next_round_number = @tranca_rodadas.select(&:classificatoria?).map(&:round_number).max.to_i + 1
    @tranca_next_knockout_round_number = @tranca_rodadas.select(&:mata_mata?).map(&:round_number).max.to_i + 1
    @tranca_classificatoria_esgotada = !Tranca::CompetitionFlow.new(@championship).classificatoria_pairings_available?(round_number: @tranca_next_round_number)
    @tranca_knockout_rounds = dashboard.knockout_rounds
    @tranca_mata_mata_encerrado = Tranca::CompetitionFlow.new(@championship).knockout_finished?
    @tranca_championship_winners = dashboard.championship_winners
    @tranca_knockout_partidas = dashboard.knockout_partidas
    @tranca_stats = dashboard.stats
    @tranca_recent_duplas = @championship.tranca_duplas.includes(:entity, :category).order(created_at: :desc).limit(3)
    @recent_tranca_source_teams = recent_tranca_source_teams
    qualified_ids = @tranca_standings.select(&:qualified?).map(&:tranca_dupla_id)
    @tranca_knockout_qualified_rows = @tranca_standings.select(&:qualified?).sort_by { |row| [ row.group_key.to_s, row.position ] }
    @tranca_knockout_candidate_rows = @tranca_standings.reject { |row| qualified_ids.include?(row.tranca_dupla_id) }
      .sort_by { |row| [ -row.points.to_i, -row.goal_diff.to_i, -row.goals_for.to_i, row.position.to_i ] }
    @tranca_knockout_selection_done = @championship.tranca_partidas.where(phase: "mata_mata", round_number: 1).exists?
  end

  def load_tranca_programacao
    @championship = @championship.class.includes(
      tranca_partidas: [
        :tranca_mesa,
        :dupla_a,
        :dupla_b
      ]
    ).find(@championship.id)
    @tranca_partidas = @championship.tranca_partidas.order(:group_key, :round_number, :id)
  end

  def recent_tranca_source_teams
    @recent_tranca_source_teams ||= @championship.recent_tranca_championships.flat_map do |source_championship|
      source_championship.categories.includes(:championships, teams: :athletes).order(:name).flat_map do |category|
        category.teams.includes(:entity, :athletes).order(:name).map do |team|
          tranca_dupla = Tranca::Dupla.find_by(source_id: team.source_id)
          next if tranca_dupla.blank? || !tranca_dupla.status_ativo? || @championship.tranca_duplas.exists?(source_id: tranca_dupla.source_id)

          team.define_singleton_method(:source_championship) { source_championship }
          team.define_singleton_method(:source_category) { category }
          team.define_singleton_method(:tranca_dupla) { tranca_dupla }
          team
        end
      end
    end.compact
  end

  def next_tranca_round_number(phase)
    existing_rounds = @championship.tranca_rodadas.where(phase: phase.to_s)
    existing_rounds.maximum(:round_number).to_i + 1
  end

  def knockout_round_label(phase, round_number)
    phase_label = case phase.to_s
    when "classificatoria" then "Classificatória"
    when "mata_mata" then "Mata-mata"
    else phase.to_s.tr("_", " ").humanize
    end

    round_number.to_i.positive? ? "Rodada #{round_number} · #{phase_label}" : phase_label
  end

  def normalize_tranca_maos_attributes(maos_attributes)
    case maos_attributes
    when ActionController::Parameters
      maos_attributes.values
    when Hash
      maos_attributes.values
    else
      Array(maos_attributes)
    end.map { |attributes| attributes.respond_to?(:to_h) ? attributes.to_h.symbolize_keys : attributes }
  end

  def build_knockout_brackets(championship)
    championship.matches
      .includes(:category, :team_a, :team_b, :winner)
      .where(phase: "mata_mata")
      .order(:category_id, :round_number, :id)
      .group_by(&:category)
      .map do |category, matches|
        rounds = matches.group_by(&:round_number).sort_by { |round_number, _| round_number.to_i }.map do |round_number, round_matches|
          {
            round_number: round_number.to_i,
            label: knockout_round_label(round_matches.first.phase, round_number),
            matches: round_matches
          }
        end

        {
          category: category,
          rounds: rounds
        }
      end
  end

  def build_tranca_summula_import_preview
    uploaded_file = params.dig(:tranca_summula_import, :file)

    if uploaded_file.blank?
      redirect_to partidas_championship_path(@championship), alert: "Envie um PDF ou foto da súmula."
      return
    end

    preview = BolaCinco::TrancaSummulaImport.new(partida: @partida, file: uploaded_file).call
    token = SecureRandom.hex(12)
    write_tranca_summula_import_preview(token, preview)
    write_tranca_summula_import_file(token, uploaded_file)

    @import_preview = preview.with_indifferent_access
    @import_token = token
    @import_file_data_url = tranca_import_file_data_url(token, @import_preview[:file_content_type], @import_preview[:file_name])
    render :import_tranca_summula
  end

  def confirm_tranca_summula_import
    token = params.dig(:tranca_summula_import, :token).to_s
    preview = read_tranca_summula_import_preview(token)

    if preview.blank?
      redirect_to partidas_championship_path(@championship), alert: "A prévia da súmula expirou. Envie o arquivo novamente."
      return
    end

    payload = params.fetch(:tranca_summula_import, {}).to_unsafe_h.deep_symbolize_keys
    apply_tranca_summula_import(preview, payload)
    delete_tranca_summula_import_preview(token)

    redirect_to partidas_championship_path(@championship), notice: "Súmula importada e conferida."
  end

  def apply_tranca_summula_import(preview, payload)
    maos_attributes = normalize_tranca_maos_attributes(payload[:maos_attributes])
    score_a = payload[:score_a].presence || preview.dig(:header, :score_a)
    score_b = payload[:score_b].presence || preview.dig(:header, :score_b)
    winner_name = payload[:winner_name].presence || preview.dig(:header, :winner_name)

    winner = case winner_name.to_s
    when @partida.dupla_a_nome.to_s then @partida.dupla_a
    when @partida.dupla_b_nome.to_s then @partida.dupla_b
    end

    Tranca::CompetitionFlow.new(@championship).record_result!(
      partida: @partida,
      score_a: score_a,
      score_b: score_b,
      status: (payload[:status].presence || "finalizado").to_s,
      winner_id: winner&.id,
      maos_attributes: maos_attributes
    )
  end

  def write_tranca_summula_import_preview(token, preview)
    path = tranca_summula_import_preview_path(token)
    FileUtils.mkdir_p(path.dirname)
    File.write(path, JSON.pretty_generate(preview))
  end

  def write_tranca_summula_import_file(token, uploaded_file)
    path = tranca_summula_import_file_path(token, uploaded_file.original_filename)
    FileUtils.mkdir_p(path.dirname)
    File.binwrite(path, File.binread(uploaded_file.path))
  end

  def read_tranca_summula_import_preview(token)
    path = tranca_summula_import_preview_path(token)
    return if token.blank? || !File.exist?(path)

    JSON.parse(File.read(path)).deep_symbolize_keys
  end

  def tranca_import_file_data_url(token, content_type, original_filename)
    return if content_type.to_s.blank? || !content_type.to_s.start_with?("image/")

    path = tranca_summula_import_file_path(token, original_filename)
    return if token.blank? || !File.exist?(path)

    "data:#{content_type.presence || "application/octet-stream"};base64,#{Base64.strict_encode64(File.binread(path))}"
  end

  def delete_tranca_summula_import_preview(token)
    path = tranca_summula_import_preview_path(token)
    File.delete(path) if File.exist?(path)
  end

  def tranca_summula_import_preview_path(token)
    Rails.root.join("tmp", "tranca_summula_imports", "#{token}.json")
  end

  def tranca_summula_import_file_path(token, original_filename)
    ext = File.extname(original_filename.to_s).presence || ".bin"
    Rails.root.join("tmp", "tranca_summula_imports", "#{token}#{ext}")
  end

  def tranca_summula_filename(partida)
    "sumula-#{partida.code.to_s.parameterize}.pdf"
  end

  def tranca_complete_summula_filename(partida)
    "sumula-completa-#{partida.code.to_s.parameterize}.pdf"
  end

  def championship_params
    params.expect(championship: [
      :source_id,
      :name,
      :season,
      :modality,
      :status,
      :start_date,
      :end_date,
      :registration_start,
      :registration_end,
      :notes,
      :logo,
      { rules: {},
        scoring: [
          :win,
          :draw,
          :loss,
          :wo,
          :woScore,
          :qualifiedPerGroup,
          :matchesPerOpponent,
          { tiebreakers: [] }
        ],
        format: [
          :mode,
          :teamCount,
          :groupCount
        ] }
    ])
  end
end
