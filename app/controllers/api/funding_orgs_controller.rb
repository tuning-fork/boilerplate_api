# frozen_string_literal: true

module Api
  class FundingOrgsController < ApplicationController
    before_action :authenticate_user, :ensure_user_is_in_organization

    def index
      @funding_orgs = FundingOrg
                      .where(organization_id: params[:organization_id])
                      .order(:name)

      render 'index.json.jb'
    end

    def create
      organization = Organization.find(params[:organization_id])
      @funding_org = FundingOrg.create!(
        website: params[:website],
        name: params[:name],
        organization_id: organization.id
      )
      render 'show.json.jb', status: 201
    end

    def show
      @funding_org = FundingOrg.find_by!(
        id: params[:id],
        organization_id: params[:organization_id]
      )
      render 'show.json.jb'
    end

    def update
      @funding_org = FundingOrg.find_by!(
        id: params[:id],
        organization_id: params[:organization_id]
      )

      @funding_org.website = params[:website] || @funding_org.website
      @funding_org.name = params[:name] || @funding_org.name
      @funding_org.archived = params[:archived].nil? ? @funding_org.archived : params[:archived]
      @funding_org.save!

      render 'show.json.jb'
    end

    def destroy
      @funding_org = FundingOrg.find_by!(
        id: params[:id],
        organization_id: params[:organization_id]
      )
      @funding_org.destroy!

      render 'show.json.jb'
    end
  end
end
