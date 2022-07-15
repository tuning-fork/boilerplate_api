# frozen_string_literal: true

module Api
  class BoilerplatesController < ApplicationController
    before_action :authenticate_user, :ensure_user_is_in_organization
    before_action :ensure_boilerplate_exists, only: %i[show update destroy]

    def index
      @boilerplates = Boilerplate
                      .where(organization_id: params[:organization_id])
                      .order(:title)

      render 'index.json.jb'
    end

    def create
      organization = Organization.find(params[:organization_id])
      category = Category.find(params[:category_id])
      @boilerplate = Boilerplate.create!(
        organization: organization,
        category: category,
        title: params[:title],
        text: params[:text],
        wordcount: params[:wordcount]
      )
      render 'show.json.jb', status: 201
    end

    def show
      render 'show.json.jb'
    end

    def update
      category = Category.find(params[:category_id])

      @boilerplate.category_id = category.id
      @boilerplate.title = params[:title] || @boilerplate.title
      @boilerplate.text = params[:text] || @boilerplate.text
      @boilerplate.wordcount = params[:wordcount] || @boilerplate.wordcount
      @boilerplate.archived = params[:archived].nil? ? @boilerplate.archived : params[:archived]
      @boilerplate.save!

      render 'show.json.jb'
    end

    def destroy
      @boilerplate.destroy!
      render 'show.json.jb'
    end

    private

    def ensure_boilerplate_exists
      @boilerplate = Boilerplate.find_by!(id: params[:id], organization_id: params[:organization_id])
    end
  end
end
