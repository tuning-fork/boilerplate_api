class Api::SessionsController < ApplicationController

  # def create
  #   user = User.find_by(email: params[:email])
  #   if user && user.authenticate(params[:password])
  #     created_jwt = 
  #       JWT.encode(
  #         {
  #           user_id: user.id, # the data to encode
  #           exp: 24.hours.from_now.to_i # the expiration time
  #         },
  #         Rails.application.credentials.fetch(:secret_key_base), 
  #         # the secret key
  #         "HS256" 
  #         # the encryption algorithm
  #       )
  #     # session[:user_id] = user.id
  #     cookies.signed[:jwt] = {value: created_jwt, httponly: true, expires: 1.hour.from_now, domain: :all}
  #     render json: { email: user.email, user_id: user.id }, status: :created
  #   else
  #     render json: {}, status: :unauthorized
  #   end
  # end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      jwt = JWT.encode(
        {
          user_id: user.id, # the data to encode
          exp: 24.hours.from_now.to_i # the expiration time
        },
        Rails.application.credentials.fetch(:secret_key_base), # the secret key
        "HS256" # the encryption algorithm
      )
      render json: { jwt: jwt, email: user.email, user_id: user.id }, status: :created
    else
      render json: {}, status: :unauthorized
    end
  end

end


# def create
#   user = User.find_by(params[:email])
#   if user && user.authenticate(params[:password])
#     created_jwt = issue_token({id: user.id})
#     cookies.signed[:jwt] = {value:  created_jwt, httponly: true}
#     render json: {username: user.username}
#   else
#     render json: {
#       error: 'Username or password incorrect'
#     }, status: 404
#   end
# end

# pre-cookies version:

# def create
#   user = User.find_by(email: params[:email])
#   if user && user.authenticate(params[:password])
#     jwt = JWT.encode(
#       {
#         user_id: user.id, # the data to encode
#         exp: 24.hours.from_now.to_i # the expiration time
#       },
#       Rails.application.credentials.fetch(:secret_key_base), # the secret key
#       "HS256" # the encryption algorithm
#     )
#     render json: { jwt: jwt, email: user.email, user_id: user.id }, status: :created
#   else
#     render json: {}, status: :unauthorized
#   end
# end
