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
    if is_associated_with_org(current_user.id)
      organization = Organization.find(params[:id])
      organization.destroy
      render json: { message: "Organization successfully destroyed." }
    else
      render json: {}, status: :not_found
    end
  end

  private
  def is_associated_with_org(user_id)
    # Join user id on organization_users join table
    # return true if associated and false if not
    true
  end
end
