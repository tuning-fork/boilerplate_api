# frozen_string_literal: true

module Api
  class CategoriesController < ApplicationController
    before_action :authenticate_user, :ensure_user_is_in_organization, :ensure_organization_exists

    def index
      @categories = @organization.categories
      render 'index.json.jb'
    end

    def create
      @category = Category.create!(**create_category_params, organization: @organization)
      render 'show.json.jb', status: :created
    end

    def show
      @category = category
      render 'show.json.jb'
    end

    def update
      @category = category
      @category.update!(update_category_params)
      render 'show.json.jb'
    end

    def destroy
      @category = category.destroy!
      render 'show.json.jb'
    end

    private

    def category
      Category.find_by!(id: params[:id], organization_id: params[:organization_id])
    end

    def create_category_params
      params.permit(%i[name])
    end

    def update_category_params
      params.permit(%i[name archived])
    end
  end
end
