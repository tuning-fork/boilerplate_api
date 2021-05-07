class Api::GrantsController < ApplicationController
  before_action :authenticate_user

  def index
    # @grants = Grant.all
    @grants = Grant.where(organization_id: params[:organization_id])

    @grants = @grants.order(id: :desc)

    render "index.json.jb"
  end

  def create
    @grant = Grant.new(
      organization_id: params[:organization_id],
      title: params[:title],
      funding_org_id: params[:funding_org_id],
      rfp_url: params[:rfp_url],
      deadline: params[:deadline],
      submitted: params[:submitted],
      successful: params[:successful],
      purpose: params[:purpose],
    )
    if @grant.save
      render "show.json.jb"
    else
      render json: { errors: @grant.errors.messages }, status: :unprocessable_entity
    end
  end

  #copy method for grant

  def copy
    @grant_to_copy = Grant.find(params[:original_grant_id])
    # @grant_to_copy = Grant.where('id = ?', params[:id])
    @grant = Grant.new(
      organization_id: @grant_to_copy.organization_id,
      title: params[:title],
      funding_org_id: @grant_to_copy.funding_org_id,
      rfp_url: params[:rfp_url],
      deadline: params[:deadline],
      submitted: false,
      successful: false,
      purpose: @grant_to_copy.purpose,
    )
    @grant.save
    if @grant.save
      grant_copy_status = true
    end 
    @sections_to_copy = Section.where("grant_id = ?", @grant_to_copy.id)
    if @sections_to_copy
      @sections_to_copy.map do |source_section|
        @section = Section.new(
          grant_id: @grant.id,
          title: source_section.title,
          text: source_section.text,
          wordcount: source_section.wordcount,
          sort_order: source_section.sort_order,
        )
        @section.save
      end 
    end  
    if grant_copy_status
      render "show.json.jb"
    else
      render json: { errors: @grant.errors.messages }, status: :unprocessable_entity
    end
  end

  def show
    @grant = Grant.find(params[:id])
    render "show.json.jb"
  end

  def update
    @grant = Grant.find(params[:id])

    @grant.organization_id = params[:organization_id] || @grant.organization_id
    @grant.title = params[:title] || @grant.title
    @grant.funding_org_id = params[:funding_org_id] || @grant.funding_org_id
    @grant.rfp_url = params[:rfp_url] || @grant.rfp_url
    @grant.deadline = params[:deadline] || @grant.deadline
    @grant.submitted = params[:submitted].nil? ? @grant.submitted : params[:submitted]
    @grant.successful = params[:successful].nil? ? @grant.successful : params[:successful]
    @grant.purpose = params[:purpose] || @grant.purpose

    if @grant.save
      render "show.json.jb"
    else
      render json: { errors: @grant.errors.messages }, status: :unprocessable_entity
    end
  end

  def destroy
    grant = Grant.find(params[:id])
    grant.destroy
    render json: { message: "Grant successfully destroyed" }
    
  end

  def reorder_sections
    Section.where("grant_id = ?", params[:id]).each do |section|
      if params[section.id.to_s]
        section.sort_order = params[section.id.to_s]
        section.save()
      end
    end
  end
end
