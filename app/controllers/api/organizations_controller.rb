class Api::OrganizationsController < ApplicationController
  before_action :authenticate_user

  def index
    @organizations = Organization
      .joins(:users)
      .where("users.id" => current_user.id)
      .order(:name)

    render "index.json.jb"
  end

  def create
    @organization = Organization.create!(name: params[:name])
    render "show.json.jb", status: 201
  end

  def show
    ensure_user_is_in_organization

    @organization = Organization.find_by!(id: params[:id])
    render "show.json.jb"
  end

  def update
    ensure_user_is_in_organization

    @organization = Organization.find_by!(id: params[:id])
    @organization.name = params[:name]
    @organization.save!

    render "show.json.jb"
  end

  def destroy
    ensure_user_is_in_organization

    @organization = Organization.find_by!(id: params[:id])
    @organization.destroy!

    render "show.json.jb"
  end

  private
  def ensure_user_is_in_organization
    unless current_user.organizations.any? { |organization| organization.id == params[:id].to_i }
      raise ActiveRecord::RecordNotFound
    end
  end
end
