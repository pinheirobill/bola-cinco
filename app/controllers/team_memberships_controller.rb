class TeamMembershipsController < ApplicationController
  def index
    return forbidden! unless scoped_team.manageable_by?(current_user) || current_user.can_view_team?(scoped_team)

    render json: scoped_team.team_memberships.includes(:user).order(created_at: :desc)
  end

  def create
    return forbidden! unless scoped_team.manageable_by?(current_user)
    championship = scoped_team.category.championship
    return forbidden! if championship.staff_limit_reached_for?(scoped_team) && !current_user.admin?

    record = scoped_team.team_memberships.new(team_membership_params)
    record.user ||= current_user
    record.source_id = default_source_id("membership") if record.source_id.blank?

    if record.save
      render json: record, status: :created
    else
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    return forbidden! unless membership.team.manageable_by?(current_user)

    membership.destroy!
    head :no_content
  end

  private

  def scoped_team
    @scoped_team ||= Team.find(params[:team_id])
  end

  def membership
    @membership ||= TeamMembership.find(params[:id])
  end

  def team_membership_params
    params.expect(team_membership: [
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
