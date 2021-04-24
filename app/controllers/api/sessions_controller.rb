class Api::SessionsController < ApplicationController

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

  def get_session
    # https://github.com/jwt/ruby-jwt
    # eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo4LCJleHAiOjE2MTkzMDQ5MTh9.XLDJh0WSFeQKFEqRtG87HVbHadCmpCKvil4kddWaSzQ
    begin
      authorization_header = request.headers["Authorization"]
      jwt = authorization_header.split(" ")[1]
      decoded_token = JWT.decode(
        jwt,
        Rails.application.credentials.fetch(:secret_key_base),
        true,
        {algorithm: "HS256"}
      )
      user_id = decoded_token[0]["user_id"]
      user = User.find_by(id: user_id)
      render json: { jwt: jwt, user: user }
    rescue => error
      puts "JWT authentication failed: #{error}"
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
