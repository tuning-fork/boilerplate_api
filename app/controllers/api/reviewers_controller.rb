class Api::ReviewersController < ApplicationController
  before_action :authenticate_user, :ensure_user_is_in_organization

  def show
    @reviewer = Reviewer.find_by!(
      grants_id: params[:grants_id],
      users_id: params[:users_id],
    )
    render "show.json.jb"
  end

  def index
    grant = Grant.find(params[:grants_id])
    @reviewers = grant.reviewers.order(:users_id)
    render "api/users/index.json.jb"
  end

  def create
    @reviewer = Reviewer.find_by(
      grants_id: params[:grants_id],
      users_id: params[:users_id],
    )
    if @reviewer
      render "show.json.jb", status: 200
    else
      @reviewer = Reviewer.create!(
        grants_id: params[:grants_id],
        users_id: params[:users_id],
      )

      render "show.json.jb", status: 201
    end
  end

  def destroy 
    @reviewer = Reviewer.find_by!(
      params[:id]
    )
    @reviewer.destroy!
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