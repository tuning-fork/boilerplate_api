class Api::OrganizationUsersController < ApplicationController
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
