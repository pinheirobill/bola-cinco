class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @categories = scoped_categories.includes(:championship, :championships, :teams).order(:name)
  end

  def show
    @category = scoped_categories.includes(:championship, :championships, teams: :entity, matches: %i[team_a team_b winner], standing_rows: :team).find(params[:id])
  end

  def update
    return forbidden! unless current_user&.admin?

    @category = scoped_categories.find(params[:id])

    if autosave_request?
      if @category.update(category_params)
        head :no_content
      else
        head :unprocessable_entity
      end
    elsif html_form_submission?
      if @category.update(category_params)
        redirect_to category_path(@category), notice: "Categoria atualizada."
      else
        render :show, status: :unprocessable_entity
      end
    elsif @category.update(category_params)
      render json: @category
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def duplicate
    return forbidden! unless current_user&.admin?

    @category = scoped_categories.includes(:championship, :championships, teams: :athletes).find(params[:id])
    duplicated_name = params[:name].to_s.strip.presence || "#{@category.name} - cópia"
    duplicated_category = @category.duplicate_as_available!(name: duplicated_name)

    redirect_target = if params[:from_modal] == "categories"
      target_championship = current_championship || raise(ActiveRecord::RecordNotFound)
      setup_championship_path(target_championship, step: "teams", modal: "categories", highlight_category_id: duplicated_category.id)
    else
      category_path(duplicated_category)
    end

    redirect_to redirect_target, notice: "Categoria duplicada e disponível para vinculação."
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: category_path(@category || params[:id]), alert: "Categoria inválida."
  rescue ActiveRecord::RecordInvalid => e
    redirect_back fallback_location: category_path(@category || params[:id]), alert: e.record.errors.full_messages.join(" · ")
  end

  private

  def scoped_categories
    return Category.includes(:championship, :championships, :teams) if current_user&.admin?
    return current_championship.categories if current_championship.present?

    Category.none
  end

  def category_params
    params.expect(category: [:name])
  end
end
