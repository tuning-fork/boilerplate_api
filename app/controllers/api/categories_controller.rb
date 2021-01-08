class Api::CategoriesController < ApplicationController
  before_action :authenticate_user

  def index
    @categories = Category.all

    @categories = @categories.order(:name)

    render "index.json.jb"
  end

  def create
    @category = Category.new(
      organization_id: params[:organization_id],
      name: params[:name],
    )
    if @category.save
      render "show.json.jb"
    else
      render json: { errors: @category.errors.messages }, status: :unprocessable_entity
    end
  end

  def show
    @category = Category.find(params[:id])
    render "show.json.jb"
  end

  def update
    @category = Category.find(params[:id])

    @category.organization_id = params[:organization_id] || @category.organization_id
    @category.name = params[:name] || @category.name

    if @category.save
      render "show.json.jb"
    else
      render json: { errors: @category.errors.messages }, status: :unprocessable_entity
    end
  end

  def destroy
    category = Category.find(params[:id])
    category.destroy
    render json: { message: "Category successfully destroyed" }
  end
end
