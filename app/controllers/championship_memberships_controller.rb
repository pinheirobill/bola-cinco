class ChampionshipMembershipsController < ApplicationController
  def index
    return forbidden! unless scoped_championship.manageable_by?(current_user)

    render json: scoped_championship.championship_memberships.includes(:user).order(created_at: :desc)
  end

  def create
    return forbidden! unless scoped_championship.manageable_by?(current_user)

    record = scoped_championship.championship_memberships.new(championship_membership_params)
    record.source_id = default_source_id("championship-membership") if record.source_id.blank?

    if record.save
      render json: record, status: :created
    else
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    return forbidden! unless membership.championship.manageable_by?(current_user)

    membership.destroy!
    head :no_content
  end

  private

  def scoped_championship
    @scoped_championship ||= Championship.find_by(id: params[:championship_id]) || Championship.find_by(slug: params[:championship_id]) || raise(ActiveRecord::RecordNotFound)
  end

  def membership
    @membership ||= ChampionshipMembership.find(params[:id])
  end

  def championship_membership_params
    params.expect(championship_membership: [
      :source_id,
      :user_id,
      :role,
      :status,
      :notes
    ])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end
end
