# frozen_string_literal: true

module Api
  class InvitationsController < ApplicationController
    before_action :ensure_organization_exists

    def index
      @invitations = @organization.pending_invitations
      render 'index.json.jb'
    end

    def create
      invitation_creator = InvitationCreator.new(create_invitation_params, @organization)
      @invitation = invitation_creator.call!
      render 'show.json.jb', status: :created
    end

    private

    def create_invitation_params
      params.permit(%i[first_name last_name email])
    end
  end
end
