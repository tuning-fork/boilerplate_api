class Api::BoilerplatesController < ApplicationController
  before_action :authenticate_user, :ensure_user_is_in_organization
  before_action :ensure_boilerplate_exists, only: [:show, :update, :destroy]

  def index
    # @boilerplates = Boilerplate.all
    @boilerplates = Boilerplate.where(organization_id: params[:organization_id])

    # @boilerplates = @boilerplates.order(:title)

    render "index.json.jb"
  end

  def create
    @boilerplate = Boilerplate.new(
      organization_id: params[:organization_id],
      category_id: params[:category_id],
      title: params[:title],
      text: params[:text],
      wordcount: params[:wordcount],
      # archived: false
    )
    if @boilerplate.save
      render "show.json.jb"
    else
      render json: { errors: @boilerplate.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render "show.json.jb"
  end

  def update
    @boilerplate.organization_id = params[:organization_id] || @boilerplate.organization_id
    @boilerplate.category_id = params[:category_id] || @boilerplate.category_id
    @boilerplate.title = params[:title] || @boilerplate.title
    @boilerplate.text = params[:text] || @boilerplate.text
    @boilerplate.wordcount = params[:wordcount] || @boilerplate.wordcount
    @boilerplate.archived = params[:archived].nil? ? @boilerplate.archived : params[:archived]

    if @boilerplate.save
      render "show.json.jb"
    else
      render json: { errors: @boilerplate.errors.messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @boilerplate.destroy
    render json: { message: "Boilerplate successfully destroyed" }
  end

  private

  def ensure_boilerplate_exists
    @boilerplate = Boilerplate.find_by!(
      organization_id: params[:organization_id],
      id: params[:id],
    )
  end
end
