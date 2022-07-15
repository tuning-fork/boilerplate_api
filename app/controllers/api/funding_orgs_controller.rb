# frozen_string_literal: true

module Api
  class FundingOrgsController < ApplicationController
    before_action :authenticate_user, :ensure_user_is_in_organization, :ensure_organization_exists

    def index
      @funding_orgs = @organization.funding_orgs.order(:name)
      render 'index.json.jb'
    end

    def create
      @funding_org = FundingOrg.create!(**create_funding_org_params, organization: @organization)
      render 'show.json.jb', status: 201
    end

    def show
      @funding_org = funding_org
      render 'show.json.jb'
    end

    def update
      @funding_org = funding_org
      @funding_org.update!(update_funding_org_params)
      render 'show.json.jb'
    end

    def destroy
      @funding_org = funding_org.destroy!
      render 'show.json.jb'
    end

    private

    def funding_org
      FundingOrg.find_by!(id: params[:id], organization_id: params[:organization_id])
    end

    def create_funding_org_params
      params.permit(%i[website name])
    end

    def update_funding_org_params
      params.permit(%i[website name archived])
    end
  end
end
