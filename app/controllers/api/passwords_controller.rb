class Api::PasswordsController < ApplicationController
  def forgot
    user = User.find_by(email: params[:email])
    user.send_password_reset if user

    # Respond regardless to prevent unintentionally leaking user's emails
    render json: { message: "If this user exists, we have sent you a password reset email." }, status: 201
  end

  def reset
    user = User.find_by!(password_reset_token: params[:token], email: params[:email])
    if user.password_token_valid? && user.reset_password(params[:password])
      session[:user_id] = user.id
      render json: { message: "Your password has been successfully reset!" }
    else
      render json: { error: ["Link expired. Try generating a new link."] }, status: 400
    end
  end
end
