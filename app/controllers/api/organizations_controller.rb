class Api::OrganizationsController < ApplicationController

  def index
    @organizations = Organization.all

    @organizations = @organizations.order(id: :asc)
    
    render 'index.json.jb'
    
  end

  def create
    @organization = Organization.new(
                        name: params[:name]
                      )
    if @organization.save
      render "show.json.jb"
    else
      render json: {errors: @organization.errors.messages}, status: :unprocessable_entity
    end
  end

  def show
    @organization = Organization.find(params[:id])
    render 'show.json.jb'
  end

  def update
    @organization = Organization.find(params[:id])

    @organization.name = params[:name] || @organization.name

    @organization.save
    render 'show.json.jb'
  end

  def destroy
    organization = Organization.find(params[:id])
    organization.destroy
    render json: {message: "Organization successfully destroyed."}
  end
end
