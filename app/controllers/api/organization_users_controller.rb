class Api::OrganizationUsersController < ApplicationController
  before_action :authenticate_user, :ensure_user_is_in_organization

  def index
    organization = Organization.find(params[:organization_id])
    @users = organization.users.order(:id)
    render "api/users/index.json.jb"
  end

  def create
    user = User.find(params[:id])
    organization = Organization.find(params[:organization_id])

    @organization_user = OrganizationUser.find_by(
      if Uuid.validate?(params[:organization_id])
        { organization_uuid: params[:organization_id], user_uuid: params[:id] }
      else
        { organization_id: params[:organization_id], user_id: params[:id] }
      end
    )

    @organization_user = OrganizationUser.create!(
      organization: organization,
      user: user,
    )

    render "show.json.jb", status: 201
  rescue ActiveRecord::RecordNotUnique => e
    render "show.json.jb", status: 200
  end

  def show
    @organization_user = OrganizationUser.find_by!(
      if Uuid.validate?(params[:organization_id])
        { organization_uuid: params[:organization_id], user_uuid: params[:id] }
      else
        { organization_id: params[:organization_id], user_id: params[:id] }
      end
    )
    render "show.json.jb"
  end
end
