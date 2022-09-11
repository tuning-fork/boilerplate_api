# frozen_string_literal: true

require 'rails_helper'

describe Api::InvitationsController do
  let(:organization) { create(:organization) }

  describe 'GET /organization/:organization_id/invitations' do
    let!(:invitations) do
      create_list(:invitation, 2, organization_id: organization.id)
    end

    it 'renders 200 with organization invitations' do
      get :index, params: { organization_id: organization.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
                                                   a_hash_including(
                                                     'id' => kind_of(String),
                                                     'created_at' => kind_of(String),
                                                     'updated_at' => kind_of(String),
                                                     'first_name' => invitations.first.first_name,
                                                     'last_name' => invitations.first.last_name,
                                                     'email' => invitations.first.email,
                                                     'expires_at' => invitations.first.expires_at.iso8601
                                                   ),
                                                   a_hash_including(
                                                     'id' => kind_of(String),
                                                     'created_at' => kind_of(String),
                                                     'updated_at' => kind_of(String),
                                                     'first_name' => invitations.second.first_name,
                                                     'last_name' => invitations.second.last_name,
                                                     'email' => invitations.second.email,
                                                     'expires_at' => invitations.second.expires_at.iso8601
                                                   )
                                                 ])
    end
  end

  describe 'POST /organization/:organization_id/invitations' do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe 'POST /organization/:organization_id/invitations/:id/accept' do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe 'PATCH /organization/:organization_id/invitations/:id/reinvite' do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe 'DELETE /organization/:organization_id/invitations/:id' do
    pending "add some examples (or delete) #{__FILE__}"
  end
end
