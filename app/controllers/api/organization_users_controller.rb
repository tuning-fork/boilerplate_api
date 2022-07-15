# frozen_string_literal: true

module Api
  class OrganizationUsersController < ApplicationController
    before_action :authenticate_user, :ensure_user_is_in_organization, :ensure_organization_exists

    def index
      @users = @organization.users
      render 'api/users/index.json.jb'
    end

    def create
      user = User.find(params[:id])
      @organization_user = OrganizationUser.create!(
        organization: @organization,
        user: user
      )

      render 'show.json.jb', status: 201
    rescue ActiveRecord::RecordNotUnique
      @organization_user = organization_user
      render 'show.json.jb', status: 200
    end

    def show
      @organization_user = organization_user
      render 'show.json.jb'
    end

    private

    def organization_user
      OrganizationUser.find_by!(user_id: params[:id], organization_id: params[:organization_id])
    end
  end
end
