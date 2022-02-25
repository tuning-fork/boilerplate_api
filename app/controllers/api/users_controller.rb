class Api::UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]

  def index
    @users = User.all
    @users = @users.order(id: :asc)
    render "index.json.jb"
  end

  def create
    @user = User.create!(
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      active: true,
    )
    render "show.json.jb", status: 201
  end

  def show
    @user = User.find(params[:id])
    render "show.json.jb"
  end

  def update
    @user = User.find(params[:id])

    # Users may only update their own attributes
    if current_user.id != @user.id
      raise ActiveRecord::RecordNotFound
    end

    @user.first_name = params[:first_name] || @user.first_name
    @user.last_name = params[:last_name] || @user.last_name
    @user.email = params[:email] || @user.email
    @user.active = params[:active].nil? || @user.active
    @user.save!

    render "show.json.jb"
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render json: { message: "User successfully destroyed" }
  end
end
