class Api::SectionsController < ApplicationController
  before_action :authenticate_user, :ensure_organization_exists, :ensure_grant_exists, :ensure_user_is_in_organization

  def index
    @sections = @grant.sections.rank(:sort_order)
    render "index.json.jb"
  end

  def create
    grant = Grant.find_by(
      if Uuid.validate?(params[:grant_id])
        { uuid: params[:grant_id] }
      else
        { id: params[:grant_id] }
      end
    )
    @section = Section.create!(
      grant_id: grant&.id,
      grant_uuid: grant&.uuid,
      title: params[:title],
      text: params[:text],
      wordcount: params[:wordcount],
      sort_order: params[:sort_order],
    )
    render "show.json.jb", status: 201
  end

  def show
    @section = Section.find_by!(
      if Uuid.validate?(params[:id])
        { uuid: params[:id], grant_uuid: params[:grant_id] }
      else
        { id: params[:id], grant_id: params[:grant_id] }
      end
    )
    render "show.json.jb"
  end

  def update
    @section = Section.find_by!(
      if Uuid.validate?(params[:id])
        { uuid: params[:id], grant_uuid: params[:grant_id] }
      else
        { id: params[:id], grant_id: params[:grant_id] }
      end
    )
    grant = Grant.find_by(
      if Uuid.validate?(params[:grant_id])
        { uuid: params[:grant_id] }
      else
        { id: params[:grant_id] }
      end
    )

    @section.grant_id = grant&.id || @section.grant_id
    @section.grant_uuid = grant&.uuid || @section.grant_uuid
    @section.title = params[:title] || @section.title
    @section.text = params[:text] || @section.text
    @section.wordcount = params[:wordcount] || @section.wordcount
    @section.sort_order = params[:sort_order] || @section.sort_order
    @section.archived = params[:archived].nil? || @section.archived
    @section.save!

    render "show.json.jb"
  end

  def destroy
    @section = Section.find_by!(
      if Uuid.validate?(params[:id])
        { uuid: params[:id], grant_uuid: params[:grant_id] }
      else
        { id: params[:id], grant_id: params[:grant_id] }
      end
    )
    @section.destroy!

    render "show.json.jb"
  end

  private

  def ensure_grant_exists
    @grant = Grant.find_by(
      organization_id: params[:organization_id],
      id: params[:grant_id],
    )
    @grant ||= Grant.find_by!(
      organization_uuid: params[:organization_id],
      uuid: params[:grant_id],
    )
  end
end
