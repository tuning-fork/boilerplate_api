# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    before_action :authenticate_user, except: [:create]

    def create
      @user = User.create!(
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        active: true
      )

      logger.info("New user created #{@user}")

      render 'show.json.jb', status: 201
    end

    def update
      # Users may only update their own attributes
      raise ActiveRecord::RecordNotFound if current_user.id != params[:id]

      @user = User.find(params[:id])
      @user.update!(update_user_params)

      render 'show.json.jb'
    end

    private

    def create_user_params
      params.permit(%i[first_name last_name email password password_confirmation])
    end

    def update_user_params
      base_params = %i[first_name last_name email]
      # Active can only change from false to true
      if params[:active]
        params.permit(base_params | [:active])
      else
        params.permit(base_params)
      end
    end
  end
end
