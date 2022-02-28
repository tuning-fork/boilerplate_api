class ApplicationController < ActionController::Base
  rescue_from JWT::DecodeError, with: :handle_unauthorized
  rescue_from JWT::VerificationError, with: :handle_unauthorized
  rescue_from JWT::ExpiredSignature, with: :handle_unauthorized
  rescue_from ActiveRecord::RecordNotFound, with: :handle_unauthorized
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

  protect_from_forgery with: :null_session
  helper_method :current_user

  def handle_unauthorized(exception)
    render status: 401, json: { errors: ["Unauthorized"] }
  end

  def handle_record_invalid(exception)
    render status: 422, json: { errors: exception.record.errors.full_messages }
  end

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

  def authenticate_user
    unless current_user
      render json: {}, status: :unauthorized
    end
  end

  def ensure_organization_exists
    @organization = Organization.find(params[:organization_id])
  end

  def ensure_user_is_in_organization(organization_id = params[:organization_id] || params[:id])
    unless current_user.is_in_organization?(organization_id)
      raise ActiveRecord::RecordNotFound
    end
  end
end
