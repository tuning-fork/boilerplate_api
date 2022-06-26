class Api::GrantsController < ApplicationController
  before_action :authenticate_user, :ensure_user_is_in_organization

  def index
    @grants = Grant
      .where(organization_id: params[:organization_id])
      .order(id: :desc)
    
    @grants = if @grants.empty?
      Grant
        .where(organization_uuid: params[:organization_id])
        .order(id: :desc)
    else 
      @grants
    end

    render "index.json.jb"
  end

  def create
    organization = Organization.find(params[:organization_id])
    funding_org = FundingOrg.find_by(
      if Uuid.validate?(params[:funding_org_id])
        { uuid: params[:funding_org_id] }
      else
        { id: params[:funding_org_id] }
      end
    )

    @grant = Grant.create!(
      organization_id: organization.id,
      organization_uuid: organization.uuid,
      title: params[:title],
      funding_org_id: funding_org&.id,
      funding_org_uuid: funding_org&.uuid,
      rfp_url: params[:rfp_url],
      deadline: params[:deadline],
      submitted: params[:submitted],
      successful: params[:successful],
      purpose: params[:purpose],
      archived: false
    )
    render "show.json.jb", status: 201
  end

  def copy
    grant_to_copy = Grant.find(params[:grant_id])
    sections_to_copy = Section.where(grant_id: params[:grant_id])

    organization = Organization.find(params[:organization_id])

    funding_org = FundingOrg.find_by(
      if Uuid.validate?(params[:funding_org_id])
        { uuid: params[:funding_org_id] }
      else
        { id: params[:funding_org_id] }
      end
    )

    @grant = Grant.create!(
      organization_id: organization.id,
      organization_uuid: organization.uuid,
      title: params[:title],
      funding_org_id: funding_org&.id,
      funding_org_uuid: funding_org&.uuid,
      rfp_url: params[:rfp_url],
      deadline: params[:deadline],
      purpose: params[:purpose],
      submitted: false,
      successful: false,
      archived: false,
      sections: sections_to_copy.map do |section|
        Section.new(
          title: section.title,
          text: section.text,
          wordcount: section.wordcount,
          sort_order: section.sort_order,
        )
      end
    )

    render "show.json.jb"
  end

  def show
    @grant = Grant.find(params[:id])
    render "show.json.jb"
  end

  def update
    @grant = Grant.find(params[:id])
    funding_org = FundingOrg.find_by(
      if Uuid.validate?(params[:funding_org_id])
        { uuid: params[:funding_org_id] }
      else
        { id: params[:funding_org_id] }
      end
    )

    @grant.title = params[:title] || @grant.title
    @grant.funding_org_id = funding_org&.id || @grant.funding_org_id
    @grant.funding_org_uuid = funding_org&.uuid || @grant.funding_org_uuid
    @grant.rfp_url = params[:rfp_url] || @grant.rfp_url
    @grant.deadline = params[:deadline] || @grant.deadline
    @grant.submitted = params[:submitted].nil? ? @grant.submitted : params[:submitted]
    @grant.successful = params[:successful].nil? ? @grant.successful : params[:successful]
    @grant.purpose = params[:purpose] || @grant.purpose
    @grant.archived = params[:archived].nil? ? @grant.archived : params[:archived]
    @grant.save!

    render "show.json.jb"
  end

  def destroy
    @grant = Grant.find(params[:id])
    @grant.destroy!

    render "show.json.jb"
  end

  def reorder_section
    Grant.find(params[:grant_id])

    @section = Section.find(params[:section_id])
    @section.sort_order_position = params[:sort_order]
    @section.save!()

    render "section.json.jb"
  end
end
