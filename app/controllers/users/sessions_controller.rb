class Users::SessionsController < Devise::SessionsController
  layout :resolve_portal_layout

  before_action :remember_portal_modality, only: %i[new create]

  private

  def remember_portal_modality
    session[:portal_modality] = params[:portal].presence if params[:portal].present?
  end

  def portal_modality
    params[:portal].presence || session[:portal_modality].presence
  end

  def resolve_portal_layout
    case portal_modality
    when "tranca"
      "tranca"
    when "football"
      "football"
    else
      "application"
    end
  end
end
