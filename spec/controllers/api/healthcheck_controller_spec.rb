# frozen_string_literal: true

require 'rails_helper'

describe Api::HealthcheckController do
  describe 'GET /api/healthcheck' do
    it 'renders 200 if server is healthy' do
      get :show
      expect(response).to have_http_status(204)
    end
  end
end
