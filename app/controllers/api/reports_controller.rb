class Api::ReportsController < ApplicationController
  before_action :authenticate_user

  def index
    @reports = Report
      .where(grant_id: params[:grant_id])
      .order(id: :asc)

    render "index.json.jb"
  end

  def create
    @report = Report.create!(
      grant_id: params[:grant_id],
      title: params[:title],
      deadline: params[:deadline],
      submitted: params[:submitted],
    )
    render "show.json.jb", status: 201
  end

  def show
    @report = Report.find(params[:id])
    render 'show.json.jb'
  end

  def update
    @report = Report.find(params[:id])

    @report.grant_id = params[:name] || @report.grant_id
    @report.title = params[:title] || @report.title
    @report.deadline = params[:deadline] || @report.deadline
    @report.submitted = params[:submitted].nil? || @report.submitted
    @report.archived = params[:archived].nil? || @report.archived
    @report.save!

    render "show.json.jb"
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy!

    render "show.json.jb"
  end
end
