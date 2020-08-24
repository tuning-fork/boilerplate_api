class Api::BoilerplatesController < ApplicationController

  # before_action :authenticate_user

  def index
    @boilerplates = Boilerplate.all

    @boilerplates = @boilerplates.order(id: :asc)
    
    render 'index.json.jb'
  end 

  def create
    @boilerplate = Boilerplate.new(
                         organization_id: params[:organization_id],
                         category_id: params[:category_id],
                         title: params[:title],
                         text: params[:text],
                         wordcount: params[:wordcount]
                        )
    if @boilerplate.save
      render "show.json.jb"
    else
      render json: {errors: @boilerplate.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def show
    @boilerplate = Boilerplate.find(params[:id])
    render 'show.json.jb'
  end

  def update
    @boilerplate = Boilerplate.find(params[:id])

    @boilerplate.organization_id = params[:organization_id] || @boilerplate.organization_id
    @boilerplate.category_id = params[:category_id] || @boilerplate.category_id
    @boilerplate.title = params[:title] || @boilerplate.title
    @boilerplate.text = params[:text] || @boilerplate.text
    @boilerplate.wordcount = params[:wordcount] || @boilerplate.wordcount

    @boilerplate.save
    render 'show.json.jb'
  end

  def destroy
    boilerplate = Boilerplate.find(params[:id])
    boilerplate.destroy
    render json: {message: "Boilerplate successfully destroyed"}
  end
  
end
