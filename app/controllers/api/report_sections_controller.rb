class Api::ReportSectionsController < ApplicationController

  before_action :authenticate_user

  def index
    @report_sections = ReportSection.all

    @report_sections = @report_sections.order(id: :asc)

    render "index.json.jb"
  end

  def create
    @report_section = ReportSection.new(
      report_id: params[:report_id],
      title: params[:title],
      text: params[:text],
      wordcount: params[:wordcount],
      sort_order: params[:sort_order],
    )
    if @report_section.save
      render "show.json.jb"
    else
      render json: { errors: @report_section.errors.messages }, status: :unprocessable_entity
    end
  end

  def show
    @report_section = ReportSection.find(params[:id])
    render "show.json.jb"
  end

  def update
    @report_section = ReportSection.find(params[:id])

    @report_section.report_id = params[:report_id] || @report_section.report_id
    @report_section.title = params[:title] || @report_section.title
    @report_section.text = params[:text] || @report_section.text
    @report_section.wordcount = params[:wordcount] || @report_section.wordcount
    @report_section.sort_order = params[:sort_order] || @report_section.sort_order

    if @report_section.save
      render "show.json.jb"
    else
      render json: { errors: @report_section.errors.messages }, status: :unprocessable_entity
    end
  end

  def destroy
    report_section = ReportSection.find(params[:id])
    report_section.destroy
    render json: { message: "ReportSection successfully destroyed" }
  end
end
