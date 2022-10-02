# frozen_string_literal: true

module Api
  class InvitationsController < ApplicationController
    before_action :ensure_organization_exists, except: [:accept]

    def index
      @invitations = @organization.pending_invitations
      render 'index.json.jb'
    end

    def create
      invitation_issuer = InvitationIssuer.new(create_invitation_params, @organization)
      @invitation = invitation_issuer.call!
      render 'show.json.jb', status: :created
    end

    def accept
      # TODO: Remove /organizations/:id/users#create
      invitation_accepter = InvitationAccepter.new(params[:token], accept_invitation_user_params)
      @invitation = invitation_accepter.call!
      render 'accept.json.jb', status: :created
    rescue InvitationAccepter::InvalidTokenException
      render status: :unprocessable_entity, json: {
        'errors' => ['Token is invalid']
      }
    end

    def reinvite
      invitation_email = Invitation.find(params[:id]).email
      invitation_issuer = InvitationIssuer.new({ email: invitation_email }, @organization)
      @invitation = invitation_issuer.call!

      render 'show.json.jb'
    end

    private

    def create_invitation_params
      params.permit(%i[first_name last_name email])
    end

    def accept_invitation_user_params
      params.permit(%i[password first_name last_name])
    end
  end
end
