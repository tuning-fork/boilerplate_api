# frozen_string_literal: true

require 'rails_helper'

describe Api::UsersController do
  user_fields = %w[
    id created_at updated_at first_name last_name email
    organizations
  ]

  describe 'POST /users' do
    it 'renders 422 when given invalid params' do
      post :create, params: {
        email: 'notanemail',
        first_name: '',
        last_name: 123,
        password: 'password',
        password_confirmation: 'passwordd'
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'errors' => [
            match(/First name can't be blank/),
            match(/First name is too short/),
            match(/Password confirmation doesn't match Password/)
          ]
        )
      )
    end

    it 'renders 201 with created user' do
      post :create, params: {
        first_name: 'Chidi',
        last_name: 'Anagonye',
        email: 'chidi@thegoodplace.com',
        password: 'JKBHSDo87aigSd8agIS&*W#GUIL',
        password_confirmation: 'JKBHSDo87aigSd8agIS&*W#GUIL'
      }

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body).keys).to contain_exactly(*user_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'id' => kind_of(String),
          'first_name' => 'Chidi',
          'last_name' => 'Anagonye',
          'email' => 'chidi@thegoodplace.com'
        )
      )
    end
  end

  describe 'PATCH /users/:id' do
    let(:user) do
      create(:user, {
               email: 'user@test.com',
               password: 'JKBHSDo87aigSd8agIS&*W#GUIL',
               first_name: 'firstname',
               last_name: 'lastname'
             })
    end

    let(:update_params) do
      {
        id: user.id,
        email: 'newemail@test.com',
        first_name: 'New first name',
        last_name: 'New last name'
      }
    end

    it 'renders 401 if user does not exist' do
      set_auth_header(user)
      patch :update, params: { **update_params, id: '4f4513a7-80ae-473b-bead-d5bd9c7a2acb' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if trying to update user different from authenticated user' do
      different_user = create(:user, {
                                email: 'diffuser@test.com',
                                password: 'JKBHSDo87aigSd8agIS&*W#GUIL',
                                first_name: 'different',
                                last_name: 'user'
                              })

      set_auth_header(user)
      patch :update, params: { **update_params, id: different_user.id }
      expect(response).to have_http_status(401)

      set_auth_header(different_user)
      patch :update, params: { **update_params, id: user.id }
      expect(response).to have_http_status(401)
    end

    it 'renders 200 with updated fields' do
      set_auth_header(user)
      patch :update, params: update_params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*user_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'id' => user.id,
          'first_name' => update_params[:first_name],
          'last_name' => update_params[:last_name],
          'email' => update_params[:email]
        )
      )
    end
  end
end
