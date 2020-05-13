class Api::FundingOrgsController < ApplicationController

  def index
    @funding_orgs = Funding_org.all

    @funding_orgs = @funding_orgs.order(id: :asc)
    
    render 'index.json.jb'
    
  end 

  def create
    @funding_org = Funding_org.new(
                        website: params[:website],
                        name: params[:name],
                        organization_id: params[:organization_id]

                      )
    if @funding_org.save
      render "show.json.jb"
    else
      render json: {errors: @funding_org.errors.messages}, status: :unprocessable_entity
    end
  end

  def show
    @funding_org = Funding_org.find(params[:id])
    render 'show.json.jb'
  end

  def update
    @funding_org = Funding_org.find(params[:id])

    @funding_org.website = params[:website] || @funding_org.website
    @funding_org.name = params[:name] || @funding_org.name
    @funding_org.organization_id = params[:organization_id] || @funding_org.organization_id

    @funding_org.save
    render 'show.json.jb'
  end

  def destroy
    funding_org = Funding_org.find(params[:id])
    funding_org.destroy
    render json: {message: "Funding_org successfully destroyed."}
  end
end
