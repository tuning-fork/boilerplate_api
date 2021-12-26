require 'rails_helper'

describe Api::OrganizationsController do
  before(:example) {
    Organization.create!([
      {
        name: 'The Bad Place',
        users: [
          User.new({
            email: 'shawn@bad.place',
            password: 'shawn',
            first_name: "Shawn",
          }),
        ],
      },
      {
        name: 'The Medium Place',
        users: [
          User.new({
            email: 'mindy@medium.place',
            password: 'mindy',
            first_name: "Mindy",
            last_name: "St. Claire",
          }),
        ],
      },
    ])
  }

  def jwt(user)
    JWT.encode(
      { user_id: user.id },
      Rails.application.credentials.fetch(:secret_key_base),
      "HS256",
    )
  end

  def set_auth_header(jwt)
    request.headers["Authorization"] = "Bearer #{jwt}"
  end

  def create_good_place_org(creator)
    Organization.create!({
      name: "The Good Place",
      users: [
        creator,
        User.new({
          email: 'tahani@good.place',
          password: 'tahani',
          first_name: "Tahani",
          last_name: "Al-Jamil",
        }),
        User.new({
          email: 'jason@good.place',
          password: 'jason',
          first_name: "Jason",
          last_name: "Mendoza",
        }),
        User.new({
          email: 'elenor@good.place',
          password: 'elenor',
          first_name: "Elenor",
          last_name: "Shellstrop",
        }),
      ]
    })
  end

  describe 'GET /organizations' do
    it 'renders 401 if unauthenticated' do
      get :index

      expect(response).to have_http_status(401)
    end

    it 'renders 200 with users\' organizations' do
      chidi = User.create!({
        email: 'chidi@good.place',
        password: 'chidi',
        first_name: "Chidi",
        last_name: "Anagonye",
      })
      shawn = User.find_by!(first_name: 'Shawn')
      mindy = User.find_by!(first_name: 'Mindy')

      set_auth_header(jwt(chidi))
      get :index
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([])

      set_auth_header(jwt(shawn))
      get :index
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
        a_hash_including(
          "name" => "The Bad Place",
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
        ),
      ])

      set_auth_header(jwt(mindy))
      get :index
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
        a_hash_including(
          "name" => "The Medium Place",
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
        ),
      ])
    end
  end

  describe 'POST /organizations' do
    it 'renders 401 if unauthenticated' do
      post :create, params: { "name" => "The Good Place" }

      expect(response).to have_http_status(401)
    end

    it 'renders 422 if given invalid or missing params' do
      chidi = User.create!({
        email: 'chidi@good.place',
        password: 'chidi',
        first_name: "Chidi",
        last_name: "Anagonye",
      })
      set_auth_header(jwt(chidi))
      post :create, params: {}

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "errors" => [match(/Name is too short/)],
        ),
      )
    end

    it 'renders 201 with created organization' do
      chidi = User.create!({
        email: 'chidi@good.place',
        password: 'chidi',
        first_name: "Chidi",
        last_name: "Anagonye",
      })

      set_auth_header(jwt(chidi))
      post :create, params: { "name" => "The Good Place" }

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "name" => "The Good Place",
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
        ),
      )
    end
  end

  describe 'GET /organizations/:organization_id' do
    let(:chidi) {
      User.create!({
        email: 'chidi@good.place',
        password: 'chidi',
        first_name: "Chidi",
        last_name: "Anagonye",
      })
    }
    let(:good_place) { create_good_place_org(chidi) }

    it 'renders 401 if unauthenticated' do
      get :show, params: { "id" => good_place.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(jwt(chidi))
      get :show, params: { "id" => "123" }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not apart of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(jwt(shawn))
      get :show, params: { "id" => good_place.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 200 with organization' do
      set_auth_header(jwt(chidi))
      get :show, params: { "id" => good_place.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "name" => good_place.name,
          "id" => good_place.id,
          "created_at" => good_place.created_at.iso8601(3),
          "updated_at" => good_place.updated_at.iso8601(3),
        ),
      )
    end
  end

  describe 'PATCH /organizations/:organization_id' do
    let(:chidi) {
      User.create!({
        email: 'chidi@good.place',
        password: 'chidi',
        first_name: "Chidi",
        last_name: "Anagonye",
      })
    }
    let(:good_place) { create_good_place_org(chidi) }

    it 'renders 401 if unauthenticated' do
      patch :update, params: { "id" => good_place.id, "name" => "The (Not So) Good Place" }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(jwt(chidi))
      patch :update, params: { "id" => "123", "name" => "The (Not So) Good Place" }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not apart of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(jwt(shawn))
      get :show, params: { "id" => good_place.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 422 if given invalid or missing params' do
      set_auth_header(jwt(chidi))
      patch :update, params: { "id" => good_place.id }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "errors" => [match(/Name is too short/)],
        ),
      )
    end

    it 'renders 200 with updated organization' do
      set_auth_header(jwt(chidi))
      patch :update, params: { "id" => good_place.id, "name" => "The (Not So) Good Place" }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "name" => "The (Not So) Good Place",
          "id" => good_place.id,
          "created_at" => good_place.created_at.iso8601(3),
          "updated_at" => kind_of(String),
        ),
      )
    end
  end

  describe 'DELETE /organizations/:organization_id' do
    let(:chidi) {
      User.create!({
        email: 'chidi@good.place',
        password: 'chidi',
        first_name: "Chidi",
        last_name: "Anagonye",
      })
    }
    let(:good_place) { create_good_place_org(chidi) }

    it 'renders 401 if unauthenticated' do
      delete :destroy, params: { "id" => good_place.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(jwt(chidi))
      delete :destroy, params: { "id" => "123" }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not apart of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(jwt(shawn))
      get :show, params: { "id" => good_place.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 200 with deleted organization' do
      set_auth_header(jwt(chidi))
      delete :destroy, params: { "id" => good_place.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "name" => good_place.name,
          "id" => good_place.id,
          "created_at" => good_place.created_at.iso8601(3),
          "updated_at" => good_place.updated_at.iso8601(3),
        ),
      )
    end
  end
end
