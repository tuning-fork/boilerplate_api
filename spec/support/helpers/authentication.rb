module Helpers
  module Authentication
    def set_auth_header(user)
      jwt = JWT.encode(
        {
          user_id: user.id,
          exp: 24.hours.from_now.to_i,
        },
        Rails.application.credentials.fetch(:secret_key_base),
        "HS256",
      )
      request.headers["Authorization"] = "Bearer #{jwt}"
    end
  end
end
