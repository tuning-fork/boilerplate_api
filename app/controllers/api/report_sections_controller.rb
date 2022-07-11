class Api::ReportSectionsController < ApplicationController
  before_action :authenticate_user,
    :ensure_organization_exists,
    :ensure_grant_exists,
    :ensure_report_exists,
    :ensure_user_is_in_organization

  def index
    @report_sections = @report.report_sections.order(id: :asc)
    render "index.json.jb"
  end

  def create
    @report_section = ReportSection.create!(
      report_id: @report.id,
      title: params[:title],
      text: params[:text],
      wordcount: params[:wordcount],
      sort_order: params[:sort_order],
    )
    render "show.json.jb", status: 201
  end

  def show
    @report_section = ReportSection.find_by(
      id: params[:id],
      report_id: params[:report_id],
    )
    @report_section ||= ReportSection.find_by!(
      { id: params[:id], report_id: params[:report_id] }
    )
    render "show.json.jb"
  end

  def update
    @report_section = ReportSection.find_by(
      id: params[:id],
      report_id: params[:report_id],
    )
    @report_section ||= ReportSection.find_by!(
      { id: params[:id], report_id: params[:report_id] }
    )
    @report_section.report_id = @report.id
    @report_section.title = params[:title] || @report_section.title
    @report_section.text = params[:text] || @report_section.text
    @report_section.wordcount = params[:wordcount] || @report_section.wordcount
    @report_section.sort_order = params[:sort_order] || @report_section.sort_order
    @report_section.archived = params[:archived].nil? || @report_section.archived
    @report_section.save!

    render "show.json.jb"
  end

  def destroy
    @report_section = ReportSection.find_by(
      id: params[:id],
      report_id: params[:report_id],
    )
    @report_section ||= ReportSection.find_by!(
      { id: params[:id], report_id: params[:report_id] }
    )
    @report_section.destroy!

    render "show.json.jb"
  end

  private

  def ensure_report_exists
    @report = Report.find_by(
      grant_id: params[:grant_id],
      id: params[:report_id],
    )
    @report ||= Report.find_by!(
      { id: params[:report_id], grant_id: params[:grant_id] }
    )
  end
end
