class Api::ReportsController < ApplicationController

  # before_action :authenticate_user

   def index
    @reports = Report.all

    @reports = @reports.order(id: :asc)
    
    render 'index.json.jb'
    
  end 

  def create
    @report = Report.new(
                        grant_id: params[:grant_id],
                        title: params[:title],
                        deadline: params[:deadline],
                        submitted: params[:submitted]

                      )
    if @report.save
      render "show.json.jb"
    else
      render json: {errors: @report.errors.messages}, status: :unprocessable_entity
    end
  end

  def show
    @report = Report.find(params[:id])
    # render json: @report, include: [:report_sections, :grant]
    render 'show.json.jb'
  end

  def update
    @report = Report.find(params[:id])

    @report.name = params[:name] || @report.name

    @report.save
    render 'show.json.jb'
  end

  def destroy
    report = ReportsController.find(params[:id])
    report.destroy
    render json: {message: "Report successfully destroyed."}
  end
end
