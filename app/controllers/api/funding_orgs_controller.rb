class Api::FundingOrgsController < ApplicationController
  before_action :authenticate_user, :ensure_user_is_in_organization

  def index
    @funding_orgs = FundingOrg
      .where(organization_id: params[:organization_id])
      .order(:name)

    @funding_orgs = if @funding_orgs.empty?
      FundingOrg
        .where(organization_uuid: params[:organization_id])
        .order(:name)
    else 
      @funding_orgs
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
    @funding_org = FundingOrg.create!(
      website: params[:website],
      name: params[:name],
      organization_id: organization&.id,
      organization_uuid: organization&.uuid,
    )
    render "show.json.jb", status: 201
  end

  def show
    @funding_org = FundingOrg.find_by(
      id: params[:id],
      organization_id: params[:organization_id],
    )
    @funding_org ||= FundingOrg.find_by!(
      if Uuid.validate?(params[:id])
        { uuid: params[:id], organization_uuid: params[:organization_id] }
      else
        { id: params[:id], organization_id: params[:organization_id] }
      end
    )
    render "show.json.jb"
  end

  def update
    @funding_org = FundingOrg.find_by(
      id: params[:id],
      organization_id: params[:organization_id],
    )
    @funding_org ||= FundingOrg.find_by!(
      if Uuid.validate?(params[:id])
        { uuid: params[:id], organization_uuid: params[:organization_id] }
      else
        { id: params[:id], organization_id: params[:organization_id] }
      end
    )

    @funding_org.website = params[:website] || @funding_org.website
    @funding_org.name = params[:name] || @funding_org.name
    @funding_org.archived = params[:archived].nil? ? @funding_org.archived : params[:archived]
    @funding_org.save!

    render "show.json.jb"
  end

  def destroy
    @funding_org = FundingOrg.find_by(
      id: params[:id],
      organization_id: params[:organization_id],
    )
    @funding_org ||= FundingOrg.find_by!(
      if Uuid.validate?(params[:id])
        { uuid: params[:id], organization_uuid: params[:organization_id] }
      else
        { id: params[:id], organization_id: params[:organization_id] }
      end
    )
    @funding_org.destroy!

    render "show.json.jb"
  end
end
