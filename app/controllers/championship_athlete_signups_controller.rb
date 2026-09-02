class ChampionshipAthleteSignupsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    load_championship
    return forbidden! unless @championship.athlete_registration_open?

    @teams = @championship.teams.includes(:entity, :category).order(:name)
    @athlete = Athlete.new
  end

  def create
    load_championship
    return forbidden! unless @championship.athlete_registration_open?

    @teams = @championship.teams.includes(:entity, :category).order(:name)
    @athlete = Athlete.new(athlete_params)
    @athlete.source_id = default_source_id("athlete") if @athlete.source_id.blank?
    @athlete.registration_submitted_at ||= Time.current

    if athlete_params[:team_id].blank?
      @athlete.errors.add(:team, "obrigatório")
    else
      @athlete.team = @teams.find_by(id: athlete_params[:team_id])
      @athlete.errors.add(:team, "inválido") if @athlete.team.nil?
      @athlete.category = @athlete.team.category if @athlete.team.present?
    end

    apply_registration_requirements(@athlete, @championship)

    if @athlete.errors.empty? && @athlete.save
      redirect_to card_athlete_path(@athlete), notice: "Atleta inscrito com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    forbidden!
  end

  private

  def load_championship
    @championship = Championship.find_by(id: params[:championship_id]) || Championship.find_by(slug: params[:championship_id]) || raise(ActiveRecord::RecordNotFound)
  end

  def athlete_params
    params.expect(athlete_signup: [
      :team_id,
      :name,
      :birth_date,
      :photo_url,
      :cpf,
      :rg,
      :birth_certificate,
      :position,
      :shirt_number,
      :cell_phone,
      :email,
      :passport,
      :voter_id,
      :gender,
      :documents_count,
      :document
    ])
  end

  def apply_registration_requirements(athlete, championship)
    championship.required_athlete_fields.each do |field|
      case field
      when "apelido"
        athlete.errors.add(:name, "obrigatório") if athlete.name.blank?
      when "foto"
        athlete.errors.add(:photo_url, "obrigatória") if athlete.photo_url.blank?
      when "cpf"
        athlete.errors.add(:cpf, "obrigatório") if athlete.cpf.blank? && athlete.document.blank?
      when "rg"
        athlete.errors.add(:rg, "obrigatório") if athlete.rg.blank?
      when "certidao_nascimento"
        athlete.errors.add(:birth_certificate, "obrigatória") if athlete.birth_certificate.blank?
      when "data_nascimento"
        athlete.errors.add(:birth_date, "obrigatória") if athlete.birth_date.blank?
      when "posicao"
        athlete.errors.add(:position, "obrigatória") if athlete.position.blank?
      when "numero_camisa"
        athlete.errors.add(:shirt_number, "obrigatório") if athlete.shirt_number.blank?
      when "celular"
        athlete.errors.add(:cell_phone, "obrigatório") if athlete.cell_phone.blank?
      when "email"
        athlete.errors.add(:email, "obrigatório") if athlete.email.blank?
      when "passaporte"
        athlete.errors.add(:passport, "obrigatório") if athlete.passport.blank?
      when "titulo_eleitor"
        athlete.errors.add(:voter_id, "obrigatório") if athlete.voter_id.blank?
      when "genero"
        athlete.errors.add(:gender, "obrigatório") if athlete.gender.blank?
      when "documentos_anexo"
        athlete.errors.add(:documents_count, "obrigatório") if athlete.documents_count.to_i <= 0
      end
    end
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end
end
