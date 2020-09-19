class Api::SectionsController < ApplicationController

  # before_action :authenticate_user

  def index
    @sections = Section.all

    @sections = @sections.order(id: :asc)

    render "index.json.jb"
  end

  def create
    @section = Section.new(
      grant_id: params[:grant_id],
      title: params[:title],
      text: params[:text],
      wordcount: params[:wordcount],
      sort_order: params[:sort_order],
    )
    if @section.save
      render "show.json.jb"
    else
      render json: { errors: @section.errors.messages }, status: :unprocessable_entity
    end
  end

  def show
    @section = Section.find(params[:id])
    render "show.json.jb"
  end

  def update
    @section = Section.find(params[:id])

    @section.grant_id = params[:grant_id] || @section.grant_id
    @section.title = params[:title] || @section.title
    @section.text = params[:text] || @section.text
    @section.wordcount = params[:wordcount] || @section.wordcount
    @section.sort_order = params[:sort_order] || @section.sort_order

    if @section.save
      render "show.json.jb"
    else
      render json: { errors: @section.errors.messages }, status: :unprocessable_entity
    end
  end

  def destroy
    section = Section.find(params[:id])
    section.destroy
    render json: { message: "Section successfully destroyed" }
  end
end
