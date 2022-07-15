# frozen_string_literal: true

require 'rails_helper'

describe Api::OrganizationsController do
  organization_fields = %w[
    id created_at updated_at name
  ]

  before(:example) do
    Organization.create!([
                           {
                             name: 'The Bad Place',
                             users: [
                               User.new({ email: 'shawn@bad.place', password: 'shawn', first_name: 'Shawn' })
                             ]
                           },
                           {
                             name: 'The Medium Place',
                             users: [
                               User.new({ email: 'mindy@medium.place', password: 'mindy', first_name: 'Mindy',
                                          last_name: 'St. Claire' })
                             ]
                           }
                         ])
  end

  def create_chidi_user
    User.create!({
                   email: 'chidi@good.place',
                   password: 'chidi',
                   first_name: 'Chidi',
                   last_name: 'Anagonye'
                 })
  end

  def create_good_place_org(creator)
    Organization.create!({
                           name: 'The Good Place',
                           users: [
                             creator,
                             User.new({ email: 'tahani@good.place', password: 'tahani', first_name: 'Tahani',
                                        last_name: 'Al-Jamil' }),
                             User.new({ email: 'jason@good.place', password: 'jason', first_name: 'Jason',
                                        last_name: 'Mendoza' }),
                             User.new({ email: 'elenor@good.place', password: 'elenor', first_name: 'Elenor',
                                        last_name: 'Shellstrop' })
                           ]
                         })
  end

  describe 'GET /organizations' do
    it 'renders 401 if unauthenticated' do
      get :index

      expect(response).to have_http_status(401)
    end

    it "renders 200 with user's organizations" do
      chidi = create_chidi_user
      shawn = User.find_by!(first_name: 'Shawn')
      mindy = User.find_by!(first_name: 'Mindy')

      set_auth_header(chidi)
      get :index
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([])

      set_auth_header(shawn)
      get :index
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
                                                   a_hash_including(
                                                     'id' => kind_of(String),
                                                     'created_at' => kind_of(String),
                                                     'updated_at' => kind_of(String),
                                                     'name' => 'The Bad Place'
                                                   )
                                                 ])

      set_auth_header(mindy)
      get :index
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
                                                   a_hash_including(
                                                     'id' => kind_of(String),
                                                     'created_at' => kind_of(String),
                                                     'updated_at' => kind_of(String),
                                                     'name' => 'The Medium Place'
                                                   )
                                                 ])
    end
  end

  describe 'POST /organizations' do
    it 'renders 401 if unauthenticated' do
      post :create, params: { name: 'The Good Place' }

      expect(response).to have_http_status(401)
    end

    it 'renders 422 if given invalid or missing params' do
      chidi = create_chidi_user
      set_auth_header(chidi)
      post :create, params: {}

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body).keys).to contain_exactly('errors')
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'errors' => [match(/Name is too short/)]
        )
      )
    end

    it 'renders 201 with created organization' do
      chidi = create_chidi_user
      set_auth_header(chidi)
      post :create, params: { name: 'The Good Place' }

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body).keys).to contain_exactly(*organization_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'id' => kind_of(String),
          'created_at' => kind_of(String),
          'updated_at' => kind_of(String),
          'name' => 'The Good Place'
        )
      )
    end

    it 'adds user to newly created organization' do
      chidi = create_chidi_user
      set_auth_header(chidi)

      expect do
        post :create, params: { name: 'The Good Place' }
      end.to change(Organization, :count)
        .and change(OrganizationUser, :count)
    end
  end

  describe 'GET /organizations/:organization_id' do
    let(:chidi) { create_chidi_user }
    let(:good_place) { create_good_place_org(chidi) }

    it 'renders 401 if unauthenticated' do
      get :show, params: { id: good_place.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      get :show, params: { id: '60915094-d0f6-46e7-be3e-73c142253471' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not member of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(shawn)
      get :show, params: { id: good_place.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 200 with organization' do
      set_auth_header(chidi)
      get :show, params: { id: good_place.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'id' => good_place.id,
          'created_at' => good_place.created_at.iso8601(3),
          'updated_at' => good_place.updated_at.iso8601(3),
          'name' => good_place.name
        )
      )
    end
  end

  describe 'PATCH /organizations/:organization_id' do
    let(:chidi) { create_chidi_user }
    let(:good_place) { create_good_place_org(chidi) }
    let(:update_organization_params) do
      {
        id: good_place.id,
        name: 'The (Not So) Good Place'
      }
    end

    it 'renders 401 if unauthenticated' do
      patch :update, params: update_organization_params

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      patch :update, params: { **update_organization_params, id: '4901ea41-a839-4f98-b098-e3651d78c36e' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not member of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(shawn)
      get :show, params: update_organization_params

      expect(response).to have_http_status(401)
    end

    it 'renders 422 if given invalid or missing params' do
      set_auth_header(chidi)
      patch :update, params: { **update_organization_params, name: '' }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body).keys).to contain_exactly('errors')
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'errors' => [match(/Name is too short/)]
        )
      )
    end

    it 'renders 200 with updated organization' do
      set_auth_header(chidi)
      patch :update, params: update_organization_params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*organization_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'id' => good_place.id,
          'created_at' => good_place.created_at.iso8601(3),
          'updated_at' => kind_of(String),
          'name' => 'The (Not So) Good Place'
        )
      )
    end
  end

  describe 'DELETE /organizations/:organization_id' do
    let(:chidi) { create_chidi_user }
    let(:good_place) { create_good_place_org(chidi) }

    it 'renders 401 if unauthenticated' do
      delete :destroy, params: { id: good_place.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      delete :destroy, params: { id: '9a4706fc-ea63-4cb3-a214-e7a065f97a44' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not member of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(shawn)
      get :show, params: { id: good_place.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 200 with deleted organization' do
      set_auth_header(chidi)
      delete :destroy, params: { id: good_place.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*organization_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'id' => good_place.id,
          'created_at' => good_place.created_at.iso8601(3),
          'updated_at' => good_place.updated_at.iso8601(3),
          'name' => good_place.name
        )
      )
    end
  end
end
