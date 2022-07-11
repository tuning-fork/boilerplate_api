class Api::ReportsController < ApplicationController
  before_action :authenticate_user, :ensure_organization_exists, :ensure_grant_exists, :ensure_user_is_in_organization

  def index
    @reports = Report
      .where(grant_id: params[:grant_id])
      .order(:title)

    render "index.json.jb"
  end

  def create
    @report = Report.create!(
      grant_id: @grant.id,
      title: params[:title],
      deadline: params[:deadline],
      submitted: params[:submitted],
    )
    render "show.json.jb", status: 201
  end

  def show
    @report = Report.find_by!(id: params[:id], grant_id: params[:grant_id])
    render 'show.json.jb'
  end

  def update
    @report = Report.find_by!(id: params[:id], grant_id: params[:grant_id])

    @report.grant_id = @grant.id
    @report.title = params[:title] || @report.title
    @report.deadline = params[:deadline] || @report.deadline
    @report.submitted = params[:submitted].nil? ? @report.submitted : params[:submitted]
    @report.archived = params[:archived].nil? || @report.archived
    @report.save!

    render "show.json.jb"
  end

  def destroy
    @report = Report.find_by!(id: params[:id], grant_id: params[:grant_id])
    @report.destroy!

    render "show.json.jb"
  end
end
