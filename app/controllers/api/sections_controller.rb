# frozen_string_literal: true

module Api
  class SectionsController < ApplicationController
    before_action :authenticate_user, :ensure_organization_exists, :ensure_grant_exists, :ensure_user_is_in_organization

    def index
      @sections = @grant.sections.rank(:sort_order)
      render 'index.json.jb'
    end

    def create
      @section = Section.create!(
        grant: @grant,
        title: params[:title],
        text: params[:text],
        wordcount: params[:wordcount],
        sort_order: params[:sort_order]
      )
      render 'show.json.jb', status: 201
    end

    def show
      @section = Section.find_by!(id: params[:id], grant_id: params[:grant_id])
      render 'show.json.jb'
    end

    def update
      @section = Section.find_by!(id: params[:id], grant_id: params[:grant_id])

      @section.grant_id = @grant.id
      @section.title = params[:title] || @section.title
      @section.text = params[:text] || @section.text
      @section.wordcount = params[:wordcount] || @section.wordcount
      @section.sort_order = params[:sort_order] || @section.sort_order
      @section.archived = params[:archived].nil? || @section.archived
      @section.save!

      render 'show.json.jb'
    end

    def destroy
      @section = Section.find_by!(id: params[:id], grant_id: params[:grant_id])
      @section.destroy!

      render 'show.json.jb'
    end
  end
end
