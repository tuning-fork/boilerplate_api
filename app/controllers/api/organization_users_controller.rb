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

    p "Trying to add user to org #{user.first_name}"
    @organization_user = OrganizationUser.create!(
      organization: organization,
      user: user,
    )
    p "Added user to org #{user.first_name}"
    
    render "show.json.jb", status: 201
  rescue ActiveRecord::RecordNotUnique => e
    p "Got record not uniqe err #{user.first_name}"
    @organization_user = OrganizationUser.find_by(organization_id: params[:organization_id], user_id: params[:id])
    render "show.json.jb", status: 200
  end

  def show
    @organization_user = OrganizationUser.find_by!(organization_id: params[:organization_id], user_id: params[:id])
    render "show.json.jb"
  end
end
