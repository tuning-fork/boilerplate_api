class Api::OrganizationUsersController < ApplicationController

  before_action :authenticate_user

  def index
    @organization_users = OrganizationUser.where(user_id: params[:user_id])

    @organization_users = @organization_users.order(id: :desc)

    render "index.json.jb"
  end

  def assoc
    organization_users = OrganizationUser.where(user_id: params[:id])
    puts params
    puts "all organization_users: #{organization_users}"
    all_org_user_ids = organization_users.map { |f| f.organization_id }
    puts "all org ids: #{all_org_user_ids}"
    all_org_user_organizations = Organization.where(id: all_org_user_ids)
    # organization_users = all_org_users
    # all_org_users = all_org_users.order(id: :desc)
    puts "all org users: #{all_org_user_organizations}"
    render :json => all_org_user_organizations
    # render :json => all_org_users
    # render "index.json.jb"
  end

  def create
    if OrganizationUser.where(
        organization_id: params[:organization_id], 
        user_id: params[:user_id])
      .exists?
      render json: { errors: @organization_user.errors.messages }, status: :unprocessable_entity
    else
      @organization_user = OrganizationUser.new(
        organization_id: params[:organization_id],
        user_id: params[:user_id]
      )
    end 
    if @organization_user.save
      render "show.json.jb"
    else
      render json: { errors: @organization_user.errors.messages }, status: :unprocessable_entity
    end
  end

  def show
    @organization_user = OrganizationUser.find(params[:id])
    render "show.json.jb"
  end
end
