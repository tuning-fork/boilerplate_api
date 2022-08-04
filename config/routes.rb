# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    post '/sessions' => 'sessions#create'
    get '/session' => 'sessions#show'

    post '/forgot_password' => 'passwords#forgot'
    post '/reset_password' => 'passwords#reset'

    post '/contact_us' => "contacts#create"

    # resources :users, only: [:create, :update]
    resources :users, only: %i[create update]

    resources :organizations do
      resources :organization_users, path: :users
      resources :boilerplates
      resources :categories
      resources :funding_orgs
      resources :grants do
        resources :sections
        resources :reports do
          resources :report_sections
        end
      end
    end

    post '/organizations/:organization_id/grants/:grant_id/copy' => 'grants#copy'

    # rubocop:disable Layout/LineLength
    patch '/organizations/:organization_id/grants/:grant_id/actions/reorder_section/:section_id' => 'grants#reorder_section'
    # rubocop:enable Layout/LineLength
  end
end
