class Api::OrganizationUsersController < ApplicationController
  def create
    @organization_user = OrganizationUser.new(
      organization_id: params[:organization_id],
      user_id: params[:user_id],
    )
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
