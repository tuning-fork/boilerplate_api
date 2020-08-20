class Api::BioGrantsController < ApplicationController
  def create
    @bio_grant = BioGrant.new(
      grant_id: params[:grant_id],
      bio_id: params[:bio_id],
    )
    if @bio_grant.save
      render "show.json.jb"
    else
      render json: { errors: @bio_grant.errors.messages }, status: :unprocessable_entity
    end
  end

  def show
    @bio_grant = BioGrant.find(params[:id])
    render "show.json.jb"
  end
end
