class Api::ReviewersController < ApplicationController
  # before_action :authenticate_user, :ensure_user_is_in_organization

  def show
    @reviewer = Reviewer.find_by!(
      grants_id: params[:grant_id],
      users_id: params[:user_id],
    )
    render "show.json.jb"
  end

  def index
    # grant = Grant.find(params[:grant_id])
    grant = Grant.find_by(
      if Uuid.validate?(params[:grant_id])
        { uuid: params[:grant_id] }
      else
        { id: params[:grant_id] }
      end
    )
    @reviewers = grant.reviewers.order(:user_id)
    render "index.json.jb"
  end

  def create
    @reviewer = Reviewer.find_by(
      grant_id: params[:grant_id],
      user_id: params[:user_id],
    )
    if @reviewer
      render "show.json.jb", status: 200
    else
      @reviewer = Reviewer.create!(
        grant_id: params[:grant_id],
        user_id: params[:user_id],
      )
      p "create reviewer ran!"
      p @reviewer.user.first_name
      render "show.json.jb", status: 201
    end
  end

  def destroy 
    @reviewer = Reviewer.find_by!(
      id: params[:id],
      grant_id: params[:grant_id],
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