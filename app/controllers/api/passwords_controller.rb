# frozen_string_literal: true

module Api
  class PasswordsController < ApplicationController
    def forgot
      user = User.find_by(email: params[:email])
      user&.send_password_reset

      # Respond regardless to prevent unintentionally leaking user's emails
      render json: { message: 'If this user exists, we have sent you a password reset email.' }, status: :created
    end

    def reset
      user = User.find_by!(password_reset_token: params[:token], email: params[:email])
      if user.password_token_valid? && user.reset_password(params[:password])
        session[:user_id] = user.id
        logger.info("Password reset for #{user}")
        render json: { message: 'Your password has been successfully reset!' }
      else
        render json: { error: ['Link expired. Try generating a new link.'] }, status: :bad_request
      end
    end
  end
end
