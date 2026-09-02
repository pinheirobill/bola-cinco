class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  layout :resolve_layout

  before_action :authenticate_user!, unless: :devise_controller?

  helper_method :current_championship
  helper_method :current_team_panel_teams
  helper_method :current_theme_name
  helper_method :current_theme_meta
  helper_method :theme_options
  helper_method :current_portal_modality
  helper_method :portal_home_path_for
  helper UiHelper

  def current_championship
    @current_championship ||= begin
      if params[:championship_id].present?
        scoped = Championship.find_by(id: params[:championship_id]) || Championship.find_by(slug: params[:championship_id])
        scoped if scoped && (scoped.visible_by?(current_user) || scoped.publicly_visible? && current_user.nil?)
      elsif session[:championship_id].present?
        scoped = Championship.find_by(id: session[:championship_id]) || Championship.find_by(slug: session[:championship_id])
        scoped if scoped && (scoped.visible_by?(current_user) || scoped.publicly_visible? && current_user.nil?)
      elsif user_signed_in? && !current_user.admin?
        current_user.accessible_championships.order(season: :desc, created_at: :desc).first || Championship.order(season: :desc, created_at: :desc).first
      elsif user_signed_in?
        Championship.order(season: :desc, created_at: :desc).first
      else
        Championship.publicly_visible.order(season: :desc, created_at: :desc).first
      end
    end
  end

  def current_team_panel_teams
    return Team.none unless user_signed_in?

    current_user.accessible_teams.includes(:entity, :category, :athletes, :team_memberships)
  end

  def current_theme_name
    current_user&.preferred_theme.presence || "corporate"
  end

  def current_theme_meta
    User.theme_meta(current_theme_name)
  end

  def theme_options
    User.theme_options
  end

  def current_portal_modality
    params[:portal].presence || session[:portal_modality].presence
  end

  def portal_home_path_for(modality)
    case modality.to_s
    when "tranca"
      tranca_root_path
    when "football"
      football_root_path
    else
      root_path
    end
  end

  def championships_for_modality(modality)
    scope = Championship.for_modality(modality)
    scope = if current_user&.admin?
      scope
    elsif user_signed_in?
      current_user.accessible_championships.merge(scope)
    else
      scope.publicly_visible
    end

    scope.order(season: :desc, created_at: :desc).includes(:categories, :matches, :standing_rows)
  end

  def after_sign_in_path_for(resource)
    case current_portal_modality
    when "tranca"
      tranca_root_path
    when "football"
      football_root_path
    else
      super
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    session.delete(:portal_modality)
    root_path
  end

  def forbidden!
    head :forbidden
  end

  def set_current_championship(championship)
    session[:championship_id] = championship.id
    @current_championship = championship
  end

  def html_form_submission?
    params[:commit].present?
  end

  def autosave_request?
    params[:autosave].present?
  end

  def resolve_layout
    return "application" if devise_controller?
    return "application" unless user_signed_in?

    "admin"
  end
end
