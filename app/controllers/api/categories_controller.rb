class Api::CategoriesController < ApplicationController
  before_action :authenticate_user, :ensure_user_is_in_organization

  def index
    @categories = Category.where(organization_id: params[:organization_id])
    render "index.json.jb"
  end

  def create
    @category = Category.create!(
      organization_id: params[:organization_id],
      name: params[:name],
    )
    render "show.json.jb", status: 201
  end

  def show
    @category = Category.find_by!(
      id: params[:id],
      organization_id: params[:organization_id],
    )
    render "show.json.jb"
  end

  def update
    @category = Category.find_by!(
      id: params[:id],
      organization_id: params[:organization_id],
    )

    @category.organization_id = params[:organization_id] || @category.organization_id
    @category.name = params[:name] || @category.name
    @category.archived = params[:archived].nil? ? @category.archived : params[:archived]
    @category.save!

    render "show.json.jb"
  end

  def destroy
    @category = Category.find_by!(
      id: params[:id],
      organization_id: params[:organization_id],
    )
    @category.destroy!

    render "show.json.jb"
  end
end
