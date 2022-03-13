class Api::OrganizationUsersController < ApplicationController
  before_action :authenticate_user, :ensure_user_is_in_organization

  def index
    organization = Organization.find(params[:organization_id])
    @users = organization.users.order(:id)
    render "api/users/index.json.jb"
  end

  def create
    user = User.find(params[:user_id])

    @organization_user = OrganizationUser.find_by(
      organization_id: params[:organization_id],
      user: params[:user_id],
    )

    if @organization_user
      render "show.json.jb", status: 200
    else
      @organization_user = OrganizationUser.create!(
        organization_id: params[:organization_id],
        user: user,
      )

      render "show.json.jb", status: 201
    end
  end

  def show
    @organization_user = OrganizationUser.find_by!(
      organization_id: params[:organization_id],
      user_id: params[:id],
    )
    render "show.json.jb"
  end
end
