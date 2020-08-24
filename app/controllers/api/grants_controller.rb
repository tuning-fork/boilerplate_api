class Api::GrantsController < ApplicationController

  # before_action :authenticate_user

  def index
    @grants = Grant.all

    @grants = @grants.order(id: :asc)
    
    render 'index.json.jb'
    
  end 

  def create
    @grant = Grant.new(
                        organization_id: params[:organization_id],
                        title: params[:title],
                        funding_org_id: params[:funding_org_id],
                        rfp_url: params[:rfp_url],
                        deadline: params[:deadline],
                        submitted: params[:submitted],
                        successful: params[:successful]
                      )
    if @grant.save
      render "show.json.jb"
    else
      render json: {errors: @grant.errors.messages}, status: :unprocessable_entity
    end
  end

  def show
    @grant = Grant.find(params[:id])
    render json: @grant, include: [:sections, :reports]
    # render 'show.json.jb'
    #this is the format for adding in report sections once I get them built out:
    # render json: @grant, include: [:sections, :reports{include: :report_sections}]

  end

  def update
    @grant = Grant.find(params[:id])

    @grant.organization_id = params[:organization_id] || @grant.organization_id
    @grant.title = params[:title] || @grant.title
    @grant.funding_org_id = params[:funding_org_id] || @grant.funding_org_id
    @grant.rfp_url = params[:rfp_url] || @grant.rfp_url
    @grant.deadline = params[:deadline] || @grant.deadline
    @grant.submitted = params[:submitted] || @grant.submitted
    @grant.successful = params[:successful] || @grant.successful

    @grant.save
    render 'show.json.jb'
  end

  def destroy
    grant = Grant.find(params[:id])
    grant.destroy
    render json: {message: "Grant successfully destroyed"}
  end
end
