class Api::ReportsController < ApplicationController

  before_action :authenticate_user

  def index
    @reports = Report.all

    @reports = @reports.order(id: :asc)

    render "index.json.jb"
  end

  def create
    @report = Report.new(
      grant_id: params[:grant_id],
      title: params[:title],
      deadline: params[:deadline],
      submitted: params[:submitted],

    )
    if @report.save
      render "show.json.jb"
    else
      render json: { errors: @report.errors.messages }, status: :unprocessable_entity
    end
  end

  def show
    @report = Report.find(params[:id])
    # render json: @report, include: [:report_sections, :grant]
    render 'show.json.jb'
  end

  def update
    @report = Report.find(params[:id])

    @report.grant_id = params[:name] || @report.grant_id
    @report.title = params[:title] || @report.title
    @report.deadline = params[:deadline] || @report.deadline
    @report.submitted = params[:submitted] || @report.submitted

    if @report.save
      render "show.json.jb"
    else
      render json: { errors: @report.errors.messages }, status: :unprocessable_entity
    end
  end

  def destroy
    report = Report.find(params[:id])
    report.destroy
    render json: { message: "Report successfully destroyed." }
  end
end
