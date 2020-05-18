class Api::BiosController < ApplicationController

  # before_action :authenticate_user

  def index
    @bios = Bio.all

    @bios = @bios.order(id: :asc)
    
    render 'index.json.jb'
  end 

  def create
    @bio = Bio.new(
                         organization_id: params[:organization_id],
                         first_name: params[:first_name],
                         last_name: params[:last_name],
                         text: params[:text]
                        )
    if @bio.save
      render "show.json.jb"
    else
      render json: {errors: @bio.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def show
    @bio = Bio.find(params[:id])
    render 'show.json.jb'
  end

  def update
    @bio = Bio.find(params[:id])

    @bio.organization_id = params[:organization_id] || @bio.organization_id
    @bio.first_name = params[:first_name] || @bio.first_name
    @bio.last_name = params[:last_name] || @bio.last_name
    @bio.text = params[:text] || @bio.text
    
    @bio.save
    render 'show.json.jb'
  end

  def destroy
    bio = Bio.find(params[:id])
    bio.destroy
    render json: {message: "Bio successfully destroyed"}
  end

end
