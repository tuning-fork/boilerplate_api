Rails.application.routes.draw do
  namespace :api do
    post "/sessions" => "sessions#create"

    get "/bios" => "bios#index"
    post "/bios" => "bios#create"
    get "/bios/:id" => "bios#show"
    patch "/bios/:id" => "bios#update"
    delete "/bios/:id" => "bios#destroy"

    get "/boilerplates" => "boilerplates#index"
    post "/boilerplates" => "boilerplates#create"
    get "/boilerplates/:id" => "boilerplates#show"
    patch "/boilerplates/:id" => "boilerplates#update"
    delete "/boilerplates/:id" => "boilerplates#destroy"

    get "/categories" => "categories#index"
    post "/categories" => "categories#create"
    get "/categories/:id" => "categories#show"
    patch "/categories/:id" => "categories#update"
    delete "/categories/:id" => "categories#destroy"

    get "/funding_orgs" => "funding_orgs#index"
    post "/funding_orgs" => "funding_orgs#create"
    get "/funding_orgs/:id" => "funding_orgs#show"
    patch "/funding_orgs/:id" => "funding_orgs#update"
    delete "/funding_orgs/:id" => "funding_orgs#destroy"

    get "/grants" => "grants#index"
    post "/grants" => "grants#create"
    get "/grants/:id" => "grants#show"
    patch "/grants/:id" => "grants#update"
    delete "/grants/:id" => "grants#destroy"
    post "/grants/:id/actions/reordersections" => "grants#reorder_sections"

    get "/grants/:id/copy" => "grants#copy"

    get "/organizations" => "organizations#index"
    post "/organizations" => "organizations#create"
    get "/organizations/:id" => "organizations#show"
    patch "/organizations/:id" => "organizations#update"
    delete "/organizations/:id" => "organizations#destroy"

    get "/reports" => "reports#index"
    post "/reports" => "reports#create"
    get "/reports/:id" => "reports#show"
    patch "/reports/:id" => "reports#update"
    delete "/reports/:id" => "reports#destroy"

    get "/sections" => "sections#index"
    post "/sections" => "sections#create"
    get "/sections/:id" => "sections#show"
    patch "/sections/:id" => "sections#update"
    delete "/sections/:id" => "sections#destroy"

    get "/report_sections" => "report_sections#index"
    post "/report_sections" => "report_sections#create"
    get "/report_sections/:id" => "report_sections#show"
    patch "/report_sections/:id" => "report_sections#update"
    delete "/report_sections/:id" => "report_sections#destroy"

    get "/users" => "users#index"
    post "/users" => "users#create"
    get "/users/:id" => "users#show"
    patch "/users/:id" => "users#update"
    delete "/users/:id" => "users#destroy"

    post "/bio_grants" => "bio_grants#create"
    get "/bio_grants/:id" => "bio_grants#show"

    post "/organization_users" => "organization_users#create"
    get "/organization_users/:id" => "organization_users#show"
  end
end
