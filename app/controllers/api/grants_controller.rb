class Api::GrantsController < ApplicationController
  before_action :authenticate_user

  def index
    @grants = Grant.all

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
    @grant_to_copy = Grant.find(params[:id])
    # @grant_to_copy = Grant.where('id = ?', params[:id])
    @grant = Grant.new(
      organization_id: @grant_to_copy.organization_id,
      title: params[:title],
      funding_org_id: @grant_to_copy.funding_org_id,
      rfp_url: params[:rfp_url],
      deadline: params[:deadline],
      submitted: params[:submitted],
      successful: params[:successful],
      purpose: @grant_to_copy.purpose,
    )
    @grant.save
    
  #copy method for sections

  def copy_sections(source_id)
    @sections_to_copy = Section.where('grant_id = ?', source_id)
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

    if @grant.save && @section.save
      render "show.json.jb"
    else
      render json: { errors: @grant.errors.messages }, status: :unprocessable_entity
    end
    # copy_sections(@grant_to_copy.id)
  end

  # def copy_sections(source_id)
  #   @sections_to_copy = Section.where('grant_id = ?', source_id)
  #   @sections_to_copy.map do |source_section|
  #     @section = Section.new(
  #       grant_id: @grant.id,
  #       title: source_section.title,
  #       text: source_section.text,
  #       wordcount: source_section.wordcount,
  #       sort_order: source_section.sort_order
  #     )
  #     @section.save
  #   end
  # end

  def show
    @grant = Grant.find(params[:id])
    # render json: @grant, include: [:sections, :reports]
    # # render 'show.json.jb'
    # #this is the format for adding in report sections once I get them built out:
    # # render json: @grant, include: [:sections, :reports{include: :report_sections}]
    render "show.json.jb"
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
