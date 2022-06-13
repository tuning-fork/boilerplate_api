class Api::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if !user
      logger.info("Attempt to create session for user without account: email=#{params[:email]}")
      raise ActiveRecord::RecordNotFound
    end

    if !user.authenticate(params[:password])
      logger.info("Incorrect password given when trying to create session for #{user}")
      raise ActiveRecord::RecordNotFound
    end

    jwt = encode_jwt(user)
    payload = {
      jwt: jwt,
      email: user.email,
      user_id: user.id,
      user_uuid: user.uuid,
    }

    logger.info("Session created for #{user}")
    render json: payload, status: 201
  end

  def get_session
    authorization_header = request.headers["Authorization"]
    token = authorization_header[/(?<=\A(Bearer ))\S+\z/] if authorization_header

    decoded_claims = decode_jwt(token)
    user_id = decoded_claims.first["user_uuid"] || decoded_claims.first["user_id"]
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
      { user_id: user.id, user_uuid: user.uuid, exp: 4.hours.from_now.to_i },
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
