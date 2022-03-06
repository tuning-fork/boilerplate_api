class Api::SessionsController < ApplicationController
  def create
    user = User.find_by!(email: params[:email])
    if user.authenticate(params[:password])
      jwt = encode_jwt(user)
      payload = {
        jwt: jwt,
        email: user.email,
        user_id: user.id,
      }

      render json: payload, status: 201
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def get_session
    authorization_header = request.headers["Authorization"]
    token = authorization_header[/(?<=\A(Bearer ))\S+\z/] if authorization_header

    decoded_claims = decode_jwt(token)
    user_id = decoded_claims.first["user_id"]
    @user = User.find(user_id)

    render "show.json.jb"
  end

  private

  def jwt_algorithm
    "HS256"
  end

  def jwt_secret
    ENV['SECRET_KEY_BASE']
  end

  def encode_jwt(user)
    JWT.encode(
      { user_id: user.id, exp: 4.hours.from_now.to_i },
      jwt_secret,
      jwt_algorithm,
    )
  end

  def decode_jwt(token)
    JWT.decode(
      token,
      jwt_secret,
      true,
      { algorithm: jwt_algorithm },
    )
  end
end
