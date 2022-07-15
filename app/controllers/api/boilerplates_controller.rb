# frozen_string_literal: true

module Api
  class BoilerplatesController < ApplicationController
    before_action :authenticate_user, :ensure_user_is_in_organization, :ensure_organization_exists

    def index
      @boilerplates = @organization.boilerplates.order(:title)
      render 'index.json.jb'
    end

    def create
      @boilerplate = Boilerplate.create!(
        **create_boilerplate_params,
        organization: @organization,
        category: category
      )
      render 'show.json.jb', status: 201
    end

    def show
      @boilerplate = boilerplate
      render 'show.json.jb'
    end

    def update
      @boilerplate = boilerplate
      @boilerplate.update!(**update_boilerplate_params, category: category)
      render 'show.json.jb'
    end

    def destroy
      @boilerplate = boilerplate.destroy!
      render 'show.json.jb'
    end

    private

    def boilerplate
      Boilerplate.find_by!(id: params[:id], organization_id: params[:organization_id])
    end

    def category
      Category.find_by!(id: params[:category_id], organization_id: params[:organization_id])
    end

    def create_boilerplate_params
      params.permit(%i[title text wordcount])
    end

    def update_boilerplate_params
      params.permit(%i[title text wordcount archived])
    end
  end
end
