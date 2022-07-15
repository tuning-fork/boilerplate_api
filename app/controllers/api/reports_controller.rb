# frozen_string_literal: true

module Api
  class ReportsController < ApplicationController
    before_action :authenticate_user, :ensure_user_is_in_organization, :ensure_organization_exists, :ensure_grant_exists

    def index
      @reports = @grant.reports.order(:title)
      render 'index.json.jb'
    end

    def create
      @report = Report.create!(**create_report_params, grant: @grant)
      render 'show.json.jb', status: 201
    end

    def show
      @report = report
      render 'show.json.jb'
    end

    def update
      @report = report
      @report.update!(**update_report_params, grant: @grant)
      render 'show.json.jb'
    end

    def destroy
      @report = report.destroy!
      render 'show.json.jb'
    end

    private

    def report
      Report.find_by!(id: params[:id], grant_id: params[:grant_id])
    end

    def create_report_params
      params.permit(%i[title deadline submitted])
    end

    def update_report_params
      params.permit(%i[title deadline submitted archived])
    end
  end
end
