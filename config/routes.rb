Rails.application.routes.draw do
  namespace :api do
    post "/sessions" => "sessions#create"
    get "/session" => "sessions#get_session"

    # routes for reset password:
    post '/forgot_password' => "passwords#forgot"
    post '/reset_password' => "passwords#reset"

    resources :organization_users
    resources :organizations do 
      resources :bios
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

    # post "/organization_users" => "organization_users#create"
    # get "/organization_users/:id" => "organization_users#show"
    # get "/organization_users" => "organization_users#index"
    get "/organization_users/assoc/:id" => "organization_users#assoc"

    # get "/bios" => "bios#index"
    # post "/bios" => "bios#create"
    # get "/bios/:id" => "bios#show"
    # patch "/bios/:id" => "bios#update"
    # delete "/bios/:id" => "bios#destroy"

    # get "/boilerplates" => "boilerplates#index"
    # post "/boilerplates" => "boilerplates#create"
    # get "/boilerplates/:id" => "boilerplates#show"
    # patch "/boilerplates/:id" => "boilerplates#update"
    # delete "/boilerplates/:id" => "boilerplates#destroy"

    # get "/categories" => "categories#index"
    # post "/categories" => "categories#create"
    # get "/categories/:id" => "categories#show"
    # patch "/categories/:id" => "categories#update"
    # delete "/categories/:id" => "categories#destroy"

    # get "/funding_orgs" => "funding_orgs#index"
    # post "/funding_orgs" => "funding_orgs#create"
    # get "/funding_orgs/:id" => "funding_orgs#show"
    # patch "/funding_orgs/:id" => "funding_orgs#update"
    # delete "/funding_orgs/:id" => "funding_orgs#destroy"

    # get "/grants" => "grants#index"
    # get "/organizations/:organization_id/grants" => "grants#index"

    # post "/grants" => "grants#create"
    get "/organizations/:organization_id/grants-finalize/:id" => "grants#show"

    patch "/grants/:id" => "grants#update"
    # delete "/grants/:id" => "grants#destroy"
    patch "/organizations/:organization_id/grants/:grant_id/actions/reorder_section/:section_id" => "grants#reorder_section"

    post "/organizations/:organization_id/grants/:grant_id/copy" => "grants#copy"

    # get "/organizations" => "organizations#index"
    # post "/organizations" => "organizations#create"
    # get "/organizations/:id" => "organizations#show"
    # patch "/organizations/:id" => "organizations#update"
    # delete "/organizations/:id" => "organizations#destroy"

    # grant has many sections

    # get "/sections" => "sections#index"
    # post "/sections" => "sections#create"
    # get "/sections/:id" => "sections#show"
    # patch "/sections/:id" => "sections#update"
    # delete "/sections/:id" => "sections#destroy"

    # grant has many reports
  
    # get "/reports" => "reports#index"
    # post "/reports" => "reports#create"
    # get "/reports/:id" => "reports#show"
    # patch "/reports/:id" => "reports#update"
    # delete "/reports/:id" => "reports#destroy"

    get "/organizations/:organization_id/reports-finalize/:id" => "reports#show"


    # # report has many report_sections 

    # get "/organizations/:organization_id/grants/:grant_id/report/:report_id/report_sections" => "report_sections#index"
    # post "/organizations/:organization_id/grants/:grant_id/report/:report_id/report_sections" => "report_sections#create"
    # get "/organizations/:organization_id/grants/:grant_id/report/:report_id/report_sections/:id" => "report_sections#show"
    # patch "/organizations/:organization_id/grants/:grant_id/report/:report_id/report_sections/:id" => "report_sections#update"
    # delete "/organizations/:organization_id/grants/:grant_id/report/:report_id/report_sections/:id" => "report_sections#destroy"

    get "/users" => "users#index"
    post "/users" => "users#create"
    get "/users/:id" => "users#show"
    patch "/users/:id" => "users#update"
    delete "/users/:id" => "users#destroy"

    # post "/bio_grants" => "bio_grants#create"
    # get "/bio_grants/:id" => "bio_grants#show"

  end
end
