# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  after_action :verify_authorized

  rescue_from JWT::DecodeError, with: :handle_unauthorized
  rescue_from JWT::VerificationError, with: :handle_unauthorized
  rescue_from JWT::ExpiredSignature, with: :handle_unauthorized
  rescue_from ActiveRecord::RecordNotFound, with: :handle_unauthorized
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from Pundit::NotAuthorizedError, with: :handle_unauthorized

  protect_from_forgery with: :null_session
  helper_method :current_user

  def handle_unauthorized(_exception)
    render status: :unauthorized, json: { errors: ['Unauthorized'] }
  end

  def handle_record_invalid(exception)
    render status: :unprocessable_entity, json: { errors: exception.record.errors.full_messages }
  end

  def current_user
    auth_headers = request.headers['Authorization']
    return nil unless auth_headers.present? && auth_headers[/(?<=\A(Bearer ))\S+\z/]

    token = auth_headers[/(?<=\A(Bearer ))\S+\z/]
    decoded_token = JWT.decode(token, ENV.fetch('SECRET_KEY_BASE'), true, { algorithm: 'HS256' })
    User.find(decoded_token[0]['user_id'])
  rescue JWT::ExpiredSignature
    nil
  end

  def authenticate_user
    render json: {}, status: :unauthorized unless current_user
  end

  def ensure_organization_exists
    @organization = Organization.find(params[:organization_id])
  end

  def ensure_user_is_in_organization(organization_id = params[:organization_id] || params[:id])
    raise ActiveRecord::RecordNotFound unless current_user.in_organization?(organization_id)
  end

  def ensure_grant_exists
    # We're searching by both the ID and organization ID to prevent someone on
    # Organization A performing operations on Organization B
    @grant = Grant.find_by!(
      organization_id: params[:organization_id],
      id: params[:grant_id]
    )
  end
end
