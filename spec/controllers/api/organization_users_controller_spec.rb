# frozen_string_literal: true

require 'rails_helper'

describe Api::OrganizationUsersController do
  user_fields = %w[
    id created_at updated_at first_name last_name email roles
  ]

  before(:example) do
    Organization.create!({
                           name: 'The Bad Place',
                           users: [
                             build(:user, first_name: 'Shawn')
                           ]
                         })
  end

  let(:chidi) do
    create(:user, first_name: 'Chidi', last_name: 'Anagonye')
  end

  let(:good_place) do
    Organization.create!({
                           name: 'The Good Place',
                           users: [
                             chidi,
                             build(:user, first_name: 'Tahani', last_name: 'Al-Jamil')
                           ]
                         })
  end

  describe 'GET /organizations/:organization_id/users' do
    it 'renders 401 if unauthenticated' do
      get :index, params: { organization_id: good_place.id }
      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      get :index, params: { organization_id: '7213c1f1-4eb3-4727-9e57-37686c6d311b' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not member of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(shawn)
      get :index, params: { organization_id: good_place.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 200 with organization users' do
      set_auth_header(chidi)
      get :index, params: { organization_id: good_place.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
                                                   a_hash_including(
                                                     'id' => good_place.users.second.id,
                                                     'created_at' => good_place.users.second.created_at.iso8601(3),
                                                     'updated_at' => good_place.users.second.updated_at.iso8601(3),
                                                     'email' => good_place.users.second.email,
                                                     'first_name' => good_place.users.second.first_name,
                                                     'last_name' => good_place.users.second.last_name
                                                   ),
                                                   a_hash_including(
                                                     'id' => good_place.users.first.id,
                                                     'created_at' => good_place.users.first.created_at.iso8601(3),
                                                     'updated_at' => good_place.users.first.updated_at.iso8601(3),
                                                     'email' => good_place.users.first.email,
                                                     'first_name' => good_place.users.first.first_name,
                                                     'last_name' => good_place.users.first.last_name
                                                   )
                                                 ])
    end
  end

  describe 'GET /organizations/:organization_id/users/:id' do
    it 'renders 401 if unauthenticated' do
      get :show, params: {
        organization_id: good_place.id,
        id: chidi.id
      }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      get :show, params: {
        organization_id: '3fa7d05f-2fed-4f2a-a8b8-a8aa19bf093b',
        id: chidi.id
      }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if boilerplate does not exist' do
      set_auth_header(chidi)
      get :show, params: {
        organization_id: good_place.id,
        id: 'b8635710-6f19-4ed0-a7b7-443fba9647a7'
      }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if user is not member of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(shawn)

      get :show, params: {
        organization_id: good_place.id,
        id: chidi.id
      }
      expect(response).to have_http_status(401)

      get :show, params: {
        organization_id: shawn.organizations.first.id,
        id: chidi.id
      }
      expect(response).to have_http_status(401)
    end

    it 'renders 200 with user' do
      set_auth_header(chidi)
      get :show, params: {
        organization_id: good_place.id,
        id: chidi.id
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*user_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'id' => kind_of(String),
          'created_at' => kind_of(String),
          'updated_at' => kind_of(String),
          'email' => chidi.email,
          'first_name' => chidi.first_name,
          'last_name' => chidi.last_name,
          'roles' => [Organization::Roles::USER]
        )
      )
    end
  end

  describe 'DELETE /organizations/:organization_id/users/:id' do
    before do
      allow_any_instance_of(OrganizationUserPolicy).to receive(:destroy?).and_return(true)
    end

    context 'when organization user policy fails' do
      before do
        allow_any_instance_of(OrganizationUserPolicy).to receive(:destroy?).and_return(false)
      end

      it 'renders 401' do
        set_auth_header(chidi)
        delete :destroy, params: { organization_id: good_place.id, id: chidi.id }

        expect(response).to have_http_status(401)
      end
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      delete :destroy, params: { organization_id: 123, id: chidi.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if user does not exist' do
      set_auth_header(chidi)
      delete :destroy, params: { organization_id: good_place, id: 123 }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if requested user is not member of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(chidi)
      delete :destroy, params: { organization_id: good_place, id: shawn.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 200 with removed organization user' do
      set_auth_header(chidi)
      delete :destroy, params: { organization_id: good_place.id, id: chidi.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*user_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'id' => chidi.id,
          'created_at' => chidi.created_at.iso8601(3),
          'updated_at' => chidi.updated_at.iso8601(3),
          'email' => chidi.email,
          'first_name' => chidi.first_name,
          'last_name' => chidi.last_name
        )
      )
    end

    it 'removes user from organization' do
      organization_user = OrganizationUser.find_by!(user_id: chidi.id, organization_id: good_place.id)

      set_auth_header(chidi)
      delete :destroy, params: { organization_id: good_place.id, id: chidi.id }

      expect do
        OrganizationUser.find(organization_user.id)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
