class NewsItemsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @news_items = scoped_news_items.order(published_at: :desc, created_at: :desc)
    @news_item = scoped_championship.news_items.new(status: :rascunho)
    @categories = scoped_championship.categories.order(:name)
    respond_to do |format|
      format.html
      format.json { render json: @news_items }
    end
  end

  def show
    @news_item = news_item
    @categories = scoped_championship.categories.order(:name)
    respond_to do |format|
      format.html
      format.json { render json: news_item }
    end
  end

  def create
    record = scoped_championship.news_items.new(news_item_params)
    record.source_id = default_source_id("news-item") if record.source_id.blank?

    if html_form_submission?
      if record.save
        redirect_to news_item_path(record), notice: "Notícia criada."
      else
        @news_items = scoped_news_items.order(published_at: :desc, created_at: :desc)
        @news_item = record
        @categories = scoped_championship.categories.order(:name)
        render :index, status: :unprocessable_entity
      end
    elsif record.save
      render json: record, status: :created
    else
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if html_form_submission?
      if news_item.update(news_item_params)
        redirect_to news_item_path(news_item), notice: "Notícia atualizada."
      else
        @news_item = news_item
        @categories = scoped_championship.categories.order(:name)
        render :show, status: :unprocessable_entity
      end
    elsif news_item.update(news_item_params)
      render json: news_item
    else
      render json: { errors: news_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    news_item.destroy!

    return redirect_to news_items_path, notice: "Notícia removida." if html_form_submission?

    head :no_content
  end

  private

  def scoped_championship
    @scoped_championship ||= if params[:championship_id].present?
      Championship.find_by(id: params[:championship_id]) || Championship.find_by(slug: params[:championship_id]) || raise(ActiveRecord::RecordNotFound)
    else
      current_championship || raise(ActiveRecord::RecordNotFound)
    end
  end

  def scoped_news_items
    scope = scoped_championship.news_items.includes(:championship, :category)
    scope = scope.status_publicada unless current_user&.admin?
    @scoped_news_items ||= scope
  end

  def news_item
    @news_item ||= scoped_news_items.find(params[:id])
  end

  def news_item_params
    params.expect(news_item: [
      :source_id,
      :category_id,
      :title,
      :body,
      :published_at,
      :pinned,
      :status,
      { source_data: {} }
    ])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end
end
