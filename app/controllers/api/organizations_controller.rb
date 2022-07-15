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
      @organization = Organization.create!(
        name: params[:name],
        users: [current_user]
      )
      logger.info("New organization #{@organization} created by #{current_user}")
      render 'show.json.jb', status: 201
    end

    def show
      @organization = Organization.find(params[:id])
      render 'show.json.jb'
    end

    def update
      @organization = Organization.find(params[:id])
      @organization.name = params[:name]
      @organization.save!

      render 'show.json.jb'
    end

    def destroy
      @organization = Organization.find(params[:id])
      @organization.destroy!

      render 'show.json.jb'
    end
  end
end
