# frozen_string_literal: true

module Api
  class ReportSectionsController < ApplicationController
    before_action :authenticate_user,
                  :ensure_user_is_in_organization,
                  :ensure_organization_exists,
                  :ensure_grant_exists,
                  :ensure_report_exists

    def index
      @report_sections = @report.report_sections
      render 'index.json.jb'
    end

    def create
      @report_section = ReportSection.create!(**create_section_params, report: @report)
      render 'show.json.jb', status: :created
    end

    def show
      @report_section = section
      render 'show.json.jb'
    end

    def update
      @report_section = section
      @report_section.update!(update_section_params)
      render 'show.json.jb'
    end

    def destroy
      @report_section = section.destroy!
      render 'show.json.jb'
    end

    private

    def ensure_report_exists
      @report = Report.find_by!(grant_id: params[:grant_id], id: params[:report_id])
    end

    def section
      ReportSection.find_by!(id: params[:id], report_id: params[:report_id])
    end

    def create_section_params
      params.permit(%i[title text wordcount sort_order])
    end

    def update_section_params
      params.permit(%i[title text wordcount sort_order archived])
    end
  end
end
