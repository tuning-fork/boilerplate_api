# frozen_string_literal: true

require 'rails_helper'

describe Api::InvitationsController do
  invitation_fields = %w[
    id created_at updated_at first_name last_name email expires_at
  ]

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
    let(:invitation_params) do
      {
        organization_id: organization.id,
        **attributes_for(:invitation).slice(:first_name, :last_name, :email)
      }
    end

    it 'render 422 with invalid or missing params' do
      post :create, params: {
        organization_id: organization.id,
        first_name: 123,
        email: true
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body).keys).to contain_exactly('errors')
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'errors' => [match(/Last name can't be blank/), match(/Last name is too short/)]
        )
      )
    end

    it 'render 201 with created invitation' do
      post :create, params: invitation_params

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body).keys).to contain_exactly(*invitation_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'id' => kind_of(String),
          'created_at' => kind_of(String),
          'updated_at' => kind_of(String),
          'first_name' => invitation_params[:first_name],
          'last_name' => invitation_params[:last_name],
          'email' => invitation_params[:email],
          'expires_at' => kind_of(String)
        )
      )
    end
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
