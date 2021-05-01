class Api::OrganizationsController < ApplicationController
  before_action :authenticate_user

  def index
    @organizations = Organization.all

    @organizations = @organizations.order(:name)

    render "index.json.jb"
  end

  def create
    @organization = Organization.new(
      name: params[:name],
    )
    if @organization.save
      render "show.json.jb"
    else
      render json: { errors: @organization.errors.messages }, status: :unprocessable_entity
    end
  end

  def show
    @organization = Organization.find(params[:id])
    render "show.json.jb"
  end

  def update
    @organization = Organization.find(params[:id])

    @organization.name = params[:name] || @organization.name

    if @organization.save
      render "show.json.jb"
    else
      render json: { errors: @organization.errors.messages }, status: :unprocessable_entity
    end
  end

  def destroy
    organization_id = params[:id].to_i
    if is_associated_with_org(organization_id, current_user)
      organization = Organization.find(organization_id)
      organization.destroy
      render json: { message: "Organization successfully destroyed." }
    else
      render json: {}, status: :not_found
    end
  end

  private
  def is_associated_with_org(organization_id, user)
    user.organizations.any? {|organization| organization.id == organization_id }
  end
end
