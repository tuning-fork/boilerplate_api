Rails.application.routes.draw do
  namespace :api do
    post "/sessions" => "sessions#create"
    get "/session" => "sessions#get_session"

    post '/forgot_password' => "passwords#forgot"
    post '/reset_password' => "passwords#reset"

    resources :users, only: [:create, :update]

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
        resources :reviewers
      end
    end

    # route for bulk adding/deleting to update saved reviewer selections (grant reviewers on grants show)
    post "/organizations/:organization_id/grants/:grant_id/reviewers/save_selected_reviewers" => "reviewers#save_selected_reviewers"

    #route for copying grants
    post "/organizations/:organization_id/grants/:grant_id/copy" => "grants#copy"
    #route for reordering grant sections
    patch "/organizations/:organization_id/grants/:grant_id/actions/reorder_section/:section_id" => "grants#reorder_section"
    #route for finalizing reports (WIP)
    get "/organizations/:organization_id/reports-finalize/:id" => "reports#show"
  end
end

# Reference guide for resources routes:
# https://guides.rubyonrails.org/routing.html
# ordinary or non-nested routes using resources:
# resources :photos
# creates seven different routes in your application, all mapping to the Photos controller:

# HTTP Verb	Path	Controller#Action	Used for
# GET	/photos	photos#index	display a list of all photos
# GET	/photos/new	photos#new	return an HTML form for creating a new photo
# POST	/photos	photos#create	create a new photo
# GET	/photos/:id	photos#show	display a specific photo
# GET	/photos/:id/edit	photos#edit	return an HTML form for editing a photo
# PATCH/PUT	/photos/:id	photos#update	update a specific photo
# DELETE	/photos/:id	photos#destroy	delete a specific photo

# nested routes using resources:
# resources :magazines do
#   resources :ads
# end

# In addition to the routes for magazines, this declaration will also route ads to an AdsController. The ad URLs require a magazine:

# HTTP Verb	Path	Controller#Action	Used for
# GET	/magazines/:magazine_id/ads	ads#index	display a list of all ads for a specific magazine
# GET	/magazines/:magazine_id/ads/new	ads#new	return an HTML form for creating a new ad belonging to a specific magazine
# POST	/magazines/:magazine_id/ads	ads#create	create a new ad belonging to a specific magazine
# GET	/magazines/:magazine_id/ads/:id	ads#show	display a specific ad belonging to a specific magazine
# GET	/magazines/:magazine_id/ads/:id/edit	ads#edit	return an HTML form for editing an ad belonging to a specific magazine
# PATCH/PUT	/magazines/:magazine_id/ads/:id	ads#update	update a specific ad belonging to a specific magazine
# DELETE	/magazines/:magazine_id/ads/:id	ads#destroy	delete a specific ad belonging to a specific magazine