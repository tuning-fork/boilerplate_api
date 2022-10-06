# frozen_string_literal: true

require 'rails_helper'

describe Api::OrganizationUsersController do
  user_fields = %w[
    id created_at updated_at first_name last_name email
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

  describe 'POST /organizations/:organization_id/users' do
    let(:michael) { create(:user, first_name: 'Michael') }

    let(:new_organization_user_params) do
      {
        organization_id: good_place.id,
        id: michael.id
      }
    end

    it 'renders 401 if unauthenticated' do
      post :create, params: new_organization_user_params
      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      post :create, params: {
        **new_organization_user_params,
        organization_id: '37e485b8-65e5-4502-a8aa-5217dd3160c3'
      }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if user does not exist' do
      set_auth_header(chidi)
      post :create, params: {
        **new_organization_user_params,
        id: 'dc846e2f-a86a-4e78-b217-6517a8bbca00'
      }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not member of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(shawn)
      post :create, params: new_organization_user_params

      expect(response).to have_http_status(401)
    end

    it 'renders 201 with added organization user' do
      set_auth_header(chidi)
      post :create, params: new_organization_user_params

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body).keys).to contain_exactly(*user_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'id' => michael.id,
          'created_at' => michael.created_at.iso8601(3),
          'updated_at' => michael.updated_at.iso8601(3),
          'email' => michael.email,
          'first_name' => michael.first_name,
          'last_name' => michael.last_name
        )
      )
    end

    it 'renders 200 when user is already in organization' do
      set_auth_header(chidi)

      post :create, params: new_organization_user_params
      expect(response).to have_http_status(201)

      post :create, params: new_organization_user_params
      expect(response).to have_http_status(200)

      expect(OrganizationUser.where(organization_id: good_place.id).count).to eq(3)
    end
  end

  describe 'GET /organizations/:organization_id/users/:id' do
    it 'renders 401 if unauthenticated' do
      get :show, params: { organization_id: good_place.id, id: chidi.id }
      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      get :show, params: { organization_id: '43698687-16b4-4c23-939d-a2a8e8b8b6b1', id: chidi.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if user does not exist' do
      set_auth_header(chidi)
      get :show, params: { organization_id: good_place, id: '351b7cbe-c753-445f-a4dc-c24597ab923e' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if requested user is not member of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(chidi)
      get :show, params: { organization_id: good_place, id: shawn.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if authenticated user is not member of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(shawn)
      get :show, params: { organization_id: good_place.id, id: chidi.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 200 with organization user' do
      set_auth_header(chidi)
      get :show, params: { organization_id: good_place.id, id: chidi.id }

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
  end

  describe 'DELETE /organizations/:organization_id/users/:id' do
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
