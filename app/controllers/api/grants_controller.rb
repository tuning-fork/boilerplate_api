# frozen_string_literal: true

module Api
  class GrantsController < ApplicationController
    before_action :authenticate_user, :ensure_user_is_in_organization, :ensure_organization_exists

    def index
      @grants = @organization.grants.order(:title)
      render 'index.json.jb'
    end

    def create
      @grant = Grant.create!(
        **create_grant_params,
        organization: @organization,
        funding_org: funding_org
      )
      render 'show.json.jb', status: :created
    end

    def copy
      @grant = Grant.create!(
        **create_grant_params,
        organization: @organization,
        funding_org: funding_org,
        sections: grant.sections.map do |section|
          Section.new(section.slice(%i[title text wordcount sort_order]))
        end
      )
      render 'show.json.jb'
    end

    def show
      @grant = grant
      render 'show.json.jb'
    end

    def update
      @grant = grant
      @grant.update!(**update_grant_params, funding_org: funding_org || grant.funding_org)
      render 'show.json.jb'
    end

    def destroy
      @grant = grant.destroy!
      render 'show.json.jb'
    end

    def reorder_section
      # Referencing grant to make sure it exists
      grant

      @section = Section.find(params[:section_id])
      @section.update!(sort_order_position: params[:sort_order])

      render 'section.json.jb'
    end

    def reorder_sections
      # Referencing grant to make sure it exists
      grant
      @sections_to_reorder = params[:sections]
      @sections_to_reorder.map do |section_to_reorder|
        @section = Section.find(section_to_reorder[:id])
        @section.update!(sort_order_position: section_to_reorder[:sort_order])
        puts section_to_reorder[:sort_order]
      end
      # @sections = Section.where(grant_id: params[:grant_id])
      # @sections.map do |section|
      #   @section = Section.find(section.id)
      #   @section.update!(sort_order_position: section.sort_order)
      # end
      @sections = grant.sections
      render 'sections.json.jb'
    end

    private

    def grant
      # :grant_id is used for actions on the grant like copy. :id is used for
      # everything else
      id = params[:id] || params[:grant_id]
      Grant.find_by!(id: id, organization_id: params[:organization_id])
    end

    def funding_org
      FundingOrg.find_by(id: params[:funding_org_id], organization_id: params[:organization_id])
    end

    def create_grant_params
      params.permit(%i[title rfp_url deadline submitted successful purpose])
    end

    def update_grant_params
      params.permit(%i[title rfp_url deadline submitted successful purpose archived])
    end
  end
end
