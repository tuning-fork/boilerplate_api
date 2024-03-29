# frozen_string_literal: true

module Api
  class SessionsController < ApplicationController
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def create
      user = User.find_by(email: params[:email])

      unless user
        logger.info("Attempt to create session for user without account: email=#{params[:email]}")
        raise ActiveRecord::RecordNotFound
      end

      unless user.authenticate(params[:password])
        logger.info("Incorrect password given when trying to create session for #{user}")
        raise ActiveRecord::RecordNotFound
      end

      jwt = encode_jwt(user)
      payload = {
        jwt:,
        email: user.email,
        user_id: user.id
      }

      logger.info("Session created for #{user}")
      render json: payload, status: :created
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    def show
      authorization_header = request.headers['Authorization']
      token = authorization_header[/(?<=\A(Bearer ))\S+\z/] if authorization_header

      decoded_claims = decode_jwt(token)
      user_id = decoded_claims.first['user_id']
      @user = User.find(user_id)

      render 'show.json.jb'
    end

    private

    def jwt_algorithm
      'HS256'
    end

    def jwt_secret
      ENV.fetch('SECRET_KEY_BASE')
    end

    def encode_jwt(user)
      JWT.encode(
        { user_id: user.id, exp: 4.hours.from_now.to_i },
        jwt_secret,
        jwt_algorithm
      )
    end

    def decode_jwt(token)
      JWT.decode(
        token,
        jwt_secret,
        true,
        { algorithm: jwt_algorithm }
      )
    end
  end
end
