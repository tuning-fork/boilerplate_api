require 'rails_helper'

describe Api::OrganizationUsersController do
  let(:user) {
    User.create!(
      email: 'test@test.test',
      password: 'testtest',
      first_name: "Test0",
      last_name: "Zero",
    )
  }
  let(:user_jwt) {
    jwt = JWT.encode(
      { user_id: user.id },
      Rails.application.credentials.fetch(:secret_key_base),
      "HS256",
    )
  }
  let(:additional_users) {
    User.create!([
      { email: 'test1@test.test', password: "testtest", first_name: "Test1", last_name: "One"},
      { email: 'test2@test.test', password: "testtest", first_name: "Test2", last_name: "Two"},
    ])
  }
  let(:organization) { Organization.create!(name: 'Test org') }

  def set_authorization_header
    request.headers["Authorization"] = "Bearer #{user_jwt}"
  end

  describe 'GET index' do
    it 'renders 200 with organization users' do
      OrganizationUser.create!([
        { organization_id: organization.id, user_id: user.id },
        { organization_id: organization.id, user_id: additional_users[0].id },
        { organization_id: organization.id, user_id: additional_users[1].id },
      ])

      set_authorization_header
      get :index, params: { "organization_id" => organization.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
        a_hash_including(
          "id" => user.id,
          "email" => "test@test.test",
          "first_name" => "Test0",
          "last_name" => "Zero",
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
        ),
        a_hash_including(
          "id" => additional_users[0].id,
          "email" => "test1@test.test",
          "first_name" => "Test1",
          "last_name" => "One",
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
        ),
        a_hash_including(
          "id" => additional_users[1].id,
          "email" => "test2@test.test",
          "first_name" => "Test2",
          "last_name" => "Two",
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
        ),
      ])
    end

    it 'renders 401 if unauthenticated' do
      get :index, params: { "organization_id" => organization.id }
      expect(response).to have_http_status(401)
    end
  end
end
