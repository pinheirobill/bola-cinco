class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :authenticate_user!, unless: :devise_controller?

  helper_method :current_championship
  helper_method :current_team_panel_teams
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
end
