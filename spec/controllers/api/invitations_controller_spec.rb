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

  describe 'POST /invitations/:token/accept' do
    let!(:invitation) { create(:invitation, organization: organization) }

    context 'when token has expired' do
      before do
        invitation.update!(expires_at: Date.yesterday)
      end

      it 'render 422' do
        post :accept, params: {
          token: invitation.token,
          password: 'password'
        }

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body).keys).to contain_exactly('errors')
        expect(JSON.parse(response.body)).to match(
          a_hash_including(
            'errors' => [match(/Token is invalid/)]
          )
        )
      end
    end

    context 'when token is invalid (no invitation found)' do
      it 'render 422' do
        post :accept, params: {
          token: 'abcdef12356',
          password: 'password'
        }

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body).keys).to contain_exactly('errors')
        expect(JSON.parse(response.body)).to match(
          a_hash_including(
            'errors' => [match(/Token is invalid/)]
          )
        )
      end
    end

    context 'when given insecure password' do
      it 'render 422' do
        post :accept, params: {
          token: invitation.token,
          password: 'abc123'
        }

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body).keys).to contain_exactly('errors')
        expect(JSON.parse(response.body)).to match(
          a_hash_including(
            'errors' => [match(/Password is too short/)]
          )
        )
      end
    end

    context 'when given valid token and password' do
      it 'render 201 with organization id and user email that was just added' do
        post :accept, params: {
          token: invitation.token,
          password: 'password'
        }

        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body).keys).to contain_exactly('organization_id')
        expect(JSON.parse(response.body)).to match(
          a_hash_including(
            'organization_id' => organization.id
          )
        )
      end
    end
  end

  describe 'PATCH /organization/:organization_id/invitations/:id/reinvite' do
    let!(:invitation) { create(:invitation, organization: organization, expires_at: Date.current) }

    context 'when organization does not exist' do
      it 'renders 401' do
        post :reinvite, params: {
          organization_id: 123,
          id: invitation.id
        }

        expect(response).to have_http_status(401)
      end
    end

    context 'when invitation does not exist' do
      it 'renders 401' do
        post :reinvite, params: {
          organization_id: invitation.organization.id,
          id: 123
        }

        expect(response).to have_http_status(401)
      end
    end

    context 'when given valid invitation' do
      it 'renders 200' do
        post :reinvite, params: {
          organization_id: invitation.organization.id,
          id: invitation.id
        }

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).keys).to contain_exactly(*invitation_fields)
        expect(JSON.parse(response.body)).to match(
          a_hash_including(
            'id' => invitation.id,
            # Calling reload here since the invitation issuer will update these fields
            'updated_at' => invitation.reload.updated_at.iso8601(3),
            'expires_at' => invitation.reload.expires_at.iso8601
          )
        )
      end
    end
  end

  describe 'DELETE /organization/:organization_id/invitations/:id' do
    let(:invitation) { create(:invitation, organization: organization) }

    context 'when organization does not exist' do
      it 'renders 401' do
        delete :destroy, params: {
          organization_id: 123,
          id: invitation.id
        }

        expect(response).to have_http_status(401)
      end
    end

    context 'when invitation does not exist' do
      it 'renders 401' do
        delete :destroy, params: {
          organization_id: organization.id,
          id: 123
        }

        expect(response).to have_http_status(401)
      end
    end

    context 'when invitation exists' do
      before do
        delete :destroy, params: {
          organization_id: organization.id,
          id: invitation.id
        }
      end

      it 'renders 200 with deleted invitation' do
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).keys).to contain_exactly(*invitation_fields)
        expect(JSON.parse(response.body)).to match(
          a_hash_including(
            'id' => invitation.id
          )
        )
      end

      it 'deletes invitation' do
        expect do
          Invitation.find(invitation.id)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
