class ThemePreferencesController < ApplicationController
  def update
    current_user.update!(preferred_theme: safe_theme_key)
    redirect_back fallback_location: root_path, notice: "Tema atualizado."
  end

  private

  def safe_theme_key
    requested_theme = params.fetch(:theme_preference, {}).permit(:theme)[:theme].to_s
    User::THEMES.key?(requested_theme) ? requested_theme : "corporate"
  end
end
