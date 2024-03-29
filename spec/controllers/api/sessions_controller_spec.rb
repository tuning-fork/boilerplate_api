# frozen_string_literal: true

require 'rails_helper'

describe Api::SessionsController do
  let(:user) do
    create(:user, {
             email: 'user@test.com',
             password: 'JKBHSDo87aigSd8agIS&*W#GUIL',
             first_name: 'firstname',
             last_name: 'lastname'
           })
  end

  describe 'POST /sessions' do
    it 'renders 401 when no user found with email' do
      post :create, params: {
        email: 'missinguser@test.com',
        password: 'JKBHSDo87aigSd8agIS&*W#GUIL'
      }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 when password does not match' do
      post :create, params: {
        email: user.email,
        password: 'incorrect password'
      }

      expect(response).to have_http_status(401)
    end

    it 'renders 201 with jwt' do
      post :create, params: {
        email: user.email,
        password: user.password
      }

      expect(response).to have_http_status(201)

      expect(JSON.parse(response.body).keys).to contain_exactly(
        'jwt', 'email', 'user_id'
      )
      expect(JSON.parse(response.body)).to match(
        'jwt' => kind_of(String),
        'email' => user.email,
        'user_id' => user.id
      )
    end
  end

  describe 'GET /session' do
    it 'renders 401 if missing authorization header' do
      get :show
      expect(response).to have_http_status(401)
    end

    it 'renders 401 if jwt is invalid' do
      request.headers['Authorization'] = 'invalid'
      get :show
      expect(response).to have_http_status(401)

      set_auth_header(build(:user, email: 'nonexistentuser@test.com'))
      get :show
      expect(response).to have_http_status(401)
    end

    it 'renders 200 with jwt' do
      user = create(:user, {
                      email: 'user@test.com',
                      password: 'JKBHSDo87aigSd8agIS&*W#GUIL',
                      first_name: 'firstname',
                      last_name: 'lastname'
                    })

      set_auth_header(user)
      get :show

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        'user' => {
          'id' => user.id,
          'first_name' => user.first_name,
          'last_name' => user.last_name,
          'email' => user.email
        }
      )
    end
  end
end
