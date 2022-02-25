class Api::OrganizationUsersController < ApplicationController
  before_action :authenticate_user, :ensure_user_is_in_organization

  def index
    organization = Organization.find(params[:organization_id])
    @users = organization.users.order(:id)
    render "api/users/index.json.jb"
  end

  def assoc
    user = OrganizationUser.where(user_id: params[:id])
    user = User.find_by(id: params[:id])
    # all_org_user_ids = organization_users.map { |f| f.organization_id }
    # all_org_user_organizations = Organization.where(id: all_org_user_ids)
    # organization_users = all_org_users
    # all_org_users = all_org_users.order(id: :desc)
    # puts "all org users: #{user.organizations}"
    render :json => user.organizations
    # render :json => all_org_users
    # render "index.json.jb"
  end

  def create
    user = User.find(params[:user_id])
    @organization_user = OrganizationUser.create!(
      organization_id: params[:organization_id],
      user: user,
    )

    render "show.json.jb", status: 201
  end

  def show
    @organization_user = OrganizationUser.find(params[:id])
    render "show.json.jb"
  end
end
