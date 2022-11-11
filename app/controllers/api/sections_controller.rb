# frozen_string_literal: true

module Api
  class SectionsController < ApplicationController
    before_action :authenticate_user, :ensure_user_is_in_organization, :ensure_organization_exists, :ensure_grant_exists

    def index
      @sections = @grant.sections.rank(:sort_order)
      # @sections = @grant.sections
      render 'index.json.jb'
    end

    def create
      @section = Section.create!(**create_section_params, grant: @grant)
      render 'show.json.jb', status: :created
    end

    def show
      @section = section
      render 'show.json.jb'
    end

    def update
      @section = section
      @section.update!(update_section_params)
      render 'show.json.jb'
    end

    def destroy
      @section = section.destroy!
      render 'show.json.jb'
    end

    private

    def section
      Section.find_by!(id: params[:id], grant_id: params[:grant_id])
    end

    def create_section_params
      params.permit(%i[title text wordcount sort_order])
    end

    def update_section_params
      params.permit(%i[title text wordcount sort_order archived])
    end
  end
end
