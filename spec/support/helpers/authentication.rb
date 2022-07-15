# frozen_string_literal: true

module Helpers
  module Authentication
    def set_auth_header(user)
      jwt = JWT.encode(
        {
          user_id: user.id,
          exp: 24.hours.from_now.to_i
        },
        ENV.fetch('SECRET_KEY_BASE'),
        'HS256'
      )
      request.headers['Authorization'] = "Bearer #{jwt}"
    end
  end
end
