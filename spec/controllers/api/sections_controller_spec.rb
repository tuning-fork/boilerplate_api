# frozen_string_literal: true

require 'rails_helper'

describe Api::SectionsController do
  section_fields = %w[
    id created_at updated_at title text wordcount sort_order
    grant_id
  ]

  before(:example) do
    org = Organization.create!({
                                 name: 'The Bad Place',
                                 users: [
                                   build(:user, first_name: 'Shawn')
                                 ],
                                 funding_orgs: [
                                   FundingOrg.new({ website: 'https://thebadplace.com', name: 'The Bad Place' })
                                 ]
                               })

    org.grants.create!([
                         {
                           title: 'Bad Place Neighborhood Grant',
                           funding_org: org.funding_orgs.first,
                           sections: [
                             Section.new({ title: 'Evil section', text: 'Lorem ipsum evil', wordcount: 3 })
                           ]
                         }
                       ])

    org
  end

  let(:chidi) do
    create(:user, first_name: 'Chidi', last_name: 'Anagonye')
  end

  let(:good_place) do
    good_place = Organization.create!({
                                        name: 'The Good Place',
                                        users: [
                                          chidi,
                                          build(:user, first_name: 'Tahani', last_name: 'Al-Jamil')
                                        ],
                                        funding_orgs: [
                                          FundingOrg.new({ website: 'https://thegoodplace.com',
                                                           name: 'The Good Place' })
                                        ]
                                      })

    good_place.grants.create!([
                                {
                                  title: 'Good Place Neighborhood Grant',
                                  funding_org: good_place.funding_orgs.first,
                                  sections: [
                                    Section.new({
                                                  title: 'Overview of the Organization',
                                                  text: 'Lorem ipsum overview',
                                                  sort_order: 0,
                                                  wordcount: 3
                                                }),
                                    Section.new({
                                                  title: 'Program Goals',
                                                  text: 'Lorem ipsum goals',
                                                  sort_order: 1,
                                                  wordcount: 3
                                                })
                                  ]
                                },
                                {
                                  title: 'Bad Janet Restorative Justice Initiative Grant',
                                  funding_org: good_place.funding_orgs.first,
                                  sections: [
                                    Section.new({
                                                  title: 'Leaders of the Program/Project',
                                                  text: 'Janet',
                                                  sort_order: 0,
                                                  wordcount: 1
                                                })
                                  ]
                                }
                              ])

    good_place
  end

  let(:grants) { good_place.grants.order(:title) }

  describe 'GET /organizations/:organization_id/grants/:grant_id/sections' do
    it 'renders 401 if unauthenticated' do
      get :index, params: {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id
      }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      get :index, params: {
        organization_id: 'a84bec1b-9602-43f9-97ed-84f41fc7977a',
        grant_id: good_place.grants.first.id
      }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if grant does not exist' do
      set_auth_header(chidi)
      get :index, params: {
        organization_id: good_place.id,
        grant_id: '4abac8cf-9d14-4d07-9567-cc26180fd330'
      }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not member of organization' do
      shawn = User.find_by!(first_name: 'Shawn')

      set_auth_header(shawn)
      get :index, params: {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id
      }

      expect(response).to have_http_status(401)
    end

    it "renders 200 with grant's sections" do
      good_place_grant = good_place.grants.find { |grant| grant.title == 'Good Place Neighborhood Grant' }

      set_auth_header(chidi)
      get :index, params: {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
                                                   a_hash_including(
                                                     'sort_order' => kind_of(Integer),
                                                     'id' => good_place_grant.sections.first.id,
                                                     'created_at' =>
                                                        good_place_grant.sections.first.created_at.iso8601(3),
                                                     'updated_at' =>
                                                        good_place_grant.sections.first.updated_at.iso8601(3),
                                                     'title' => good_place_grant.sections.first.title,
                                                     'text' => good_place_grant.sections.first.text,
                                                     'wordcount' => good_place_grant.sections.first.wordcount
                                                   ),
                                                   a_hash_including(
                                                     'sort_order' => kind_of(Integer),
                                                     'id' => good_place_grant.sections.second.id,
                                                     'created_at' =>
                                                        good_place_grant.sections.second.created_at.iso8601(3),
                                                     'updated_at' =>
                                                        good_place_grant.sections.second.updated_at.iso8601(3),
                                                     'title' => good_place_grant.sections.second.title,
                                                     'text' => good_place_grant.sections.second.text,
                                                     'wordcount' => good_place_grant.sections.second.wordcount
                                                   )
                                                 ])
    end
  end

  describe 'POST /organizations/:organization_id/grants/:grant_id/sections' do
    let(:new_section_params) do
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        title: 'New section',
        text: 'This is the new section',
        wordcount: 5,
        sort_order: good_place.grants.first.sections.last.sort_order + 1
      }
    end

    it 'renders 401 if unauthenticated' do
      post :create, params: new_section_params

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      post :create, params: { **new_section_params, organization_id: '572a0706-82d0-4a03-a204-6ea3cb00ba2e' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if grant does not exist' do
      set_auth_header(chidi)
      post :create, params: { **new_section_params, grant_id: '4a7766f4-1931-483d-a8ac-52b8926b7ad0' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not member of organization' do
      shawn = User.find_by!(first_name: 'Shawn')

      set_auth_header(shawn)
      post :create, params: new_section_params

      expect(response).to have_http_status(401)
    end

    it 'renders 422 if given invalid or missing params' do
      set_auth_header(chidi)
      post :create, params: {
        **new_section_params,
        title: ''
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body).keys).to contain_exactly('errors')
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'errors' => [match(/Title is too short/)]
        )
      )
    end

    it 'renders 201 with created section' do
      set_auth_header(chidi)
      post :create, params: new_section_params

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body).keys).to contain_exactly(*section_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'id' => kind_of(String),
          'created_at' => kind_of(String),
          'updated_at' => kind_of(String),
          'sort_order' => kind_of(Integer),
          'title' => new_section_params[:title],
          'text' => new_section_params[:text],
          'wordcount' => new_section_params[:wordcount]
        )
      )
    end
  end

  describe 'GET /organizations/:organization_id/grants/:grant_id/sections/:id' do
    let(:section) do
      Section.create!({
                        grant: good_place.grants.first,
                        title: 'Existing section',
                        text: 'This is an existing section to fetch',
                        wordcount: 7,
                        sort_order: good_place.grants.first.sections.last.sort_order + 1
                      })
    end
    let(:params) do
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        id: section.id
      }
    end

    it 'renders 401 if unauthenticated' do
      get(:show, params:)

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      get :show, params: { **params, organization_id: '20168e70-f20d-4381-8688-a9d763e8415e' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if grant does not exist' do
      set_auth_header(chidi)
      get :show, params: { **params, grant_id: '01685a93-2e0d-47fb-992e-c134a95369d0' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if section does not exist' do
      set_auth_header(chidi)
      get :show, params: { **params, id: '214210ce-6872-4ffb-a378-3ec7bb59ec4b' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if section is not apart of grant' do
      different_section = good_place.grants.second.sections.first
      set_auth_header(chidi)
      get :show, params: { **params, id: different_section.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not apart of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(shawn)

      get(:show, params:)
      expect(response).to have_http_status(401)

      get :show, params: { **params, organization_id: shawn.organizations.first.id }
      expect(response).to have_http_status(401)
    end

    it 'renders 200 with organization' do
      set_auth_header(chidi)
      get(:show, params:)

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*section_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'sort_order' => kind_of(Integer),
          'id' => section.id,
          'created_at' => section.created_at.iso8601(3),
          'updated_at' => section.updated_at.iso8601(3),
          'title' => section.title,
          'text' => section.text,
          'wordcount' => section.wordcount
        )
      )
    end
  end

  describe 'PATCH /organizations/:organization_id/grants/:grant_id/sections/:id' do
    let(:section) do
      Section.create!({
                        grant: good_place.grants.first,
                        title: 'Existing section',
                        text: 'This is an existing section to update',
                        wordcount: 7,
                        sort_order: good_place.grants.first.sections.last.sort_order + 1
                      })
    end
    let(:update_section_params) do
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        id: section.id,
        title: 'Updated section title',
        text: 'Updated section text',
        wordcount: 3
      }
    end

    it 'renders 401 if unauthenticated' do
      patch :update, params: update_section_params

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      patch :update, params: { **update_section_params, organization_id: '0ba4237c-a998-4e8a-826f-209e14d6b139' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if grant does not exist' do
      set_auth_header(chidi)
      patch :update, params: { **update_section_params, grant_id: '94080f12-094d-40f1-a344-4fe442407794123' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if section does not exist' do
      set_auth_header(chidi)
      patch :update, params: { **update_section_params, id: 'c90c3ede-d58e-4651-95d0-6f86c473be1b' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if section is not apart of grant' do
      different_section = good_place.grants.second.sections.first
      set_auth_header(chidi)
      patch :update, params: { **update_section_params, id: different_section.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not apart of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(shawn)

      patch :update, params: update_section_params
      expect(response).to have_http_status(401)

      patch :update, params: { **update_section_params, organization_id: shawn.organizations.first.id }
      expect(response).to have_http_status(401)
    end

    it 'renders 422 if given invalid or missing params' do
      set_auth_header(chidi)
      patch :update, params: {
        **update_section_params,
        title: ''
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body).keys).to contain_exactly('errors')
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'errors' => [match(/Title is too short/)]
        )
      )
    end

    it 'renders 200 with updated section' do
      set_auth_header(chidi)
      patch :update, params: update_section_params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*section_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'id' => section.id,
          'created_at' => section.created_at.iso8601(3),
          'updated_at' => kind_of(String),
          'sort_order' => kind_of(Integer),
          'title' => update_section_params[:title],
          'text' => update_section_params[:text],
          'wordcount' => update_section_params[:wordcount]
        )
      )
    end
  end

  describe 'DELETE /organizations/:organization_id/grants/:grant_id/sections/:id' do
    let(:section) do
      Section.create!({
                        grant: good_place.grants.first,
                        title: 'Existing section',
                        text: 'This is an existing section to delete',
                        wordcount: 7,
                        sort_order: good_place.grants.first.sections.last.sort_order + 1
                      })
    end
    let(:delete_section_params) do
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        id: section.id
      }
    end

    it 'renders 401 if unauthenticated' do
      delete :destroy, params: delete_section_params

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_section_params, organization_id: '0c18a016-62e1-49fe-a5f4-d3cca53b4cfb' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if grant does not exist' do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_section_params, grant_id: '2598d96f-cfcf-49d7-b8cc-653b7d4619ef' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if section does not exist' do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_section_params, id: 'deb81300-9d05-40de-99b8-25430fe9f4f6' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if section is not apart of grant' do
      different_section = good_place.grants.second.sections.first
      set_auth_header(chidi)
      delete :destroy, params: { **delete_section_params, id: different_section.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not apart of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(shawn)

      delete :destroy, params: delete_section_params
      expect(response).to have_http_status(401)

      delete :destroy, params: { **delete_section_params, organization_id: shawn.organizations.first.id }
      expect(response).to have_http_status(401)
    end

    it 'renders 200 with deleted section' do
      set_auth_header(chidi)
      delete :destroy, params: delete_section_params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*section_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'sort_order' => kind_of(Integer),
          'id' => section.id,
          'created_at' => section.created_at.iso8601(3),
          'updated_at' => section.updated_at.iso8601(3),
          'title' => section.title,
          'text' => section.text,
          'wordcount' => section.wordcount
        )
      )
    end
  end
end
