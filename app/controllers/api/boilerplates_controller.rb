class Api::BoilerplatesController < ApplicationController
  before_action :authenticate_user, :ensure_user_is_in_organization
  before_action :ensure_boilerplate_exists, only: [:show, :update, :destroy]

  def index
    @boilerplates = Boilerplate.where(organization_id: params[:organization_id])
    
    @boilerplates = if @boilerplates.empty?
      Boilerplate.where(organization_uuid: params[:organization_id])
    else 
      @boilerplates
    end

    render "index.json.jb"
  end

  def create
    organization = Organization.find_by(
      if Uuid.validate?(params[:organization_id])
        { uuid: params[:organization_id] }
      else
        { id: params[:organization_id] }
      end
    )
    category = Category.find_by(
      if Uuid.validate?(params[:category_id])
        { uuid: params[:category_id] }
      else
        { id: params[:category_id] }
      end
    )
    @boilerplate = Boilerplate.create!(
      organization_id: organization&.id,
      organization_uuid: organization&.uuid,
      category_id: category&.id,
      category_uuid: category&.uuid,
      title: params[:title],
      text: params[:text],
      wordcount: params[:wordcount],
    )
    render "show.json.jb", status: 201
  end

  def show
    render "show.json.jb"
  end

  def update
    category = Category.find_by(
      if Uuid.validate?(params[:category_id])
        { uuid: params[:category_id] }
      else
        { id: params[:category_id] }
      end
    )

    @boilerplate.category_id = category&.id || @boilerplate.category_id
    @boilerplate.category_uuid = category&.uuid || @boilerplate.category_uuid
    @boilerplate.title = params[:title] || @boilerplate.title
    @boilerplate.text = params[:text] || @boilerplate.text
    @boilerplate.wordcount = params[:wordcount] || @boilerplate.wordcount
    @boilerplate.archived = params[:archived].nil? ? @boilerplate.archived : params[:archived]
    @boilerplate.save!

    render "show.json.jb"
  end

  def destroy
    @boilerplate.destroy!
    render "show.json.jb"
  end

  private

  def ensure_boilerplate_exists
    @boilerplate = Boilerplate.find_by!(
      if Uuid.validate?(params[:id])
        { uuid: params[:id], organization_uuid: params[:organization_id] }
      else
        { id: params[:id], organization_id: params[:organization_id] }
      end
    )
  end
end
