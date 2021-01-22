class ApplicationController < ActionController::Base
    # include ::ActionController::Cookies
    # include ::ActionDispatch::Cookies::CookieJars

    protect_from_forgery with: :null_session
    # protect_from_forgery with: :exception

    def current_user
      auth_headers = request.headers["Authorization"]
      if auth_headers.present? && auth_headers[/(?<=\A(Bearer ))\S+\z/]
        token = auth_headers[/(?<=\A(Bearer ))\S+\z/]
        begin
          decoded_token = JWT.decode(
            token,
            Rails.application.credentials.fetch(:secret_key_base),
            true,
            { algorithm: "HS256" }
          )
          User.find_by(id: decoded_token[0]["user_id"])
        rescue JWT::ExpiredSignature
          nil
        end
      end
    end

    helper_method :current_user
    
    def authenticate_user
      unless current_user
        render json: {}, status: :unauthorized
      end
    end

  #   def current_user
  #     jwt = cookies.signed[:jwt]
  #     if jwt
  #       token = jwt
  #       begin
  #         decoded_token = JWT.decode(
  #           token,
  #           Rails.application.credentials.fetch(:secret_key_base),
  #           true,
  #           { algorithm: "HS256" }
  #         )
  #         User.find_by(id: decoded_token[0]["user_id"])
  #       rescue JWT::ExpiredSignature
  #         nil
  #       end
  #     end
  #   end

  #   helper_method :current_user

  #   JWT_SECRET = Rails.application.secrets.secret_key_base

  #   def decode_jwt(token)
  #     begin
  #     body = JWT.decode(token, JWT_SECRET)
  #       if body then HashWithIndifferentAccess.new body[0] else return false end
  #     rescue JWT::ExpiredSignature, JWT::VerificationError => e
  #       return false
  #     rescue JWT::DecodeError, JWT::VerificationError => e
  #       return false
  #     end
  #   end

  #   def authenticate_user
  #     jwt = cookies.signed[:jwt]
  #     decode_jwt(jwt)
  #     unless jwt
  #       render json: {}, status: :unauthorized
  #     end
  #   end

  end

# pre-cookie state

# def current_user
#   auth_headers = request.headers["Authorization"]
#   if auth_headers.present? && auth_headers[/(?<=\A(Bearer ))\S+\z/]
#     token = auth_headers[/(?<=\A(Bearer ))\S+\z/]
#     begin
#       decoded_token = JWT.decode(
#         token,
#         Rails.application.credentials.fetch(:secret_key_base),
#         true,
#         { algorithm: "HS256" }
#       )
#       User.find_by(id: decoded_token[0]["user_id"])
#     rescue JWT::ExpiredSignature
#       nil
#     end
#   end
# end
# helper_method :current_user
# def authenticate_user
#   unless current_user
#     render json: {}, status: :unauthorized
#   end
# end