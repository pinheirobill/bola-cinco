class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.includes(:entity, :championship, :category).order(due_date: :asc, created_at: :desc)
  end

  def show
    @invoice = Invoice.includes(:entity, :championship, :category).find(params[:id])
  end
end
