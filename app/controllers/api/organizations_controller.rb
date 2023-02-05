# frozen_string_literal: true

module Api
  class OrganizationsController < ApplicationController
    before_action :authenticate_user
    before_action :ensure_user_is_in_organization, except: %i[index create]

    def index
      @organizations = Organization
                       .joins(:users)
                       .where('users.id' => current_user.id)
                       .order(:name)

      render 'index.json.jb'
    end

    def create
      @organization = OrganizationCreator.new.call!(create_organization_params, current_user)
      render 'show.json.jb', status: :created
    end

    def show
      @organization = organization
      render 'show.json.jb'
    end

    def update
      @organization = organization
      @organization.update!(update_organization_params)
      render 'show.json.jb'
    end

    private

    def organization
      Organization.find(params[:id])
    end

    def create_organization_params
      params.permit(%i[name])
    end

    def update_organization_params
      params.permit(%i[name])
    end
  end
end
