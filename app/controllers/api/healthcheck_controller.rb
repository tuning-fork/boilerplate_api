# frozen_string_literal: true

module Api
  class HealthcheckController < ApplicationController
    def show
      ActiveRecord::Base.connection.execute('SELECT 1+1')
      head :no_content
    end
  end
end
