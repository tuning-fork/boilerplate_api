# frozen_string_literal: true

module Api
  class InvitationsController < ApplicationController
    before_action :ensure_organization_exists

    def index
      @invitations = @organization.pending_invitations
      render 'index.json.jb'
    end
  end
end
