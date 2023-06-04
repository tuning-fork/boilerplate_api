# frozen_string_literal: true

require 'rails_helper'

describe Api::PasswordsController do
  let(:user) do
    create(:user, email: 'user@test.com', password: 'password', first_name: 'user')
  end

  describe 'POST /forgot_password' do
    it 'renders 201 if no user found with email' do
      post :forgot, params: { email: 'test@test.test' }

      expect(response).to have_http_status(201)
    end

    it 'renders 201 for existing users' do
      post :forgot, params: { email: user.email }

      expect(response).to have_http_status(201)
    end
  end

  describe 'POST /reset_password' do
    let(:reset_token) do
      user.password_reset_sent_at = Time.zone.now
      user.password_reset_token = 'test-reset-token'
      user.save!
      user.password_reset_token
    end
    let(:params) do
      {
        email: user.email,
        token: reset_token,
        password: 'ij(ASDH8PGA*Dp#Q1f'
      }
    end

    it 'renders 401 if no user found with email' do
      post :reset, params: {
        **params,
        email: 'test@test.test'
      }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if no user found with reset token' do
      post :reset, params: {
        **params,
        token: 'invalid-reset-token'
      }

      expect(response).to have_http_status(401)
    end

    it 'renders 400 if reset token expired' do
      user_with_expired_token = create(:user, {
                                         email: 'expired@test.com',
                                         password: 'current password',
                                         first_name: 'user',
                                         password_reset_token: 'expired-token',
                                         password_reset_sent_at: Time.zone.now - 2.hours
                                       })

      post :reset, params: {
        email: user_with_expired_token.email,
        token: user_with_expired_token.password_reset_token,
        password: 'new password for user'
      }

      expect(response).to have_http_status(400)
    end

    it 'renders 422 if given insecure password' do
      post :reset, params: {
        **params,
        password: 'abc123'
      }

      expect(response).to have_http_status(422)
    end

    it 'renders 200 with valid params' do
      post(:reset, params:)

      expect(response).to have_http_status(200)
    end
  end
end
