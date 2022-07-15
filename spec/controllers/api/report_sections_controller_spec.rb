# frozen_string_literal: true

require 'rails_helper'

describe Api::ReportSectionsController do
  report_section_fields = %w[
    id created_at updated_at title text wordcount sort_order
    report_id
  ]

  before(:example) do
    org = Organization.create!({
                                 name: 'The Bad Place',
                                 users: [
                                   User.new({ email: 'shawn@bad.place', password: 'shawn', first_name: 'Shawn' })
                                 ],
                                 funding_orgs: [
                                   FundingOrg.new({ website: 'https://thebadplace.com', name: 'The Bad Place' })
                                 ]
                               })

    org.grants.create!([
                         {
                           title: 'Bad Place Neighborhood Grant',
                           funding_org: org.funding_orgs.first,
                           reports: [
                             Report.new({
                                          title: 'Bad Report',
                                          deadline: DateTime.now.next_week.utc,
                                          submitted: true,
                                          report_sections: [
                                            ReportSection.new({ title: 'Evil Report Section', text: 'Lorem ipsum evil',
                                                                wordcount: 3 })
                                          ]
                                        })
                           ]
                         }
                       ])

    org
  end

  let(:chidi) do
    User.create!({ email: 'chidi@good.place', password: 'chidi', first_name: 'Chidi', last_name: 'Anagonye' })
  end

  let(:good_place) do
    good_place = Organization.create!({
                                        name: 'The Good Place',
                                        users: [
                                          chidi,
                                          User.new({ email: 'tahani@good.place', password: 'tahani',
                                                     first_name: 'Tahani', last_name: 'Al-Jamil' })
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
                                  reports: [
                                    Report.new({
                                                 title: 'Report 1',
                                                 deadline: DateTime.now.utc,
                                                 submitted: true,
                                                 report_sections: [
                                                   ReportSection.new({ title: 'Report Section 1', text: 'Lorem ipsum 1',
                                                                       wordcount: 3, sort_order: 0 }),
                                                   ReportSection.new({ title: 'Report Section 2', text: 'Lorem ipsum 2',
                                                                       wordcount: 3, sort_order: 1 })
                                                 ]
                                               })
                                  ]
                                },
                                {
                                  title: 'Bad Janet Restorative Justice Initiative Grant',
                                  funding_org: good_place.funding_orgs.first,
                                  reports: [
                                    Report.new({
                                                 title: 'Janet Report',
                                                 deadline: DateTime.now.next_week.utc,
                                                 submitted: true,
                                                 report_sections: [
                                                   ReportSection.new({ title: 'Janet report', text: 'Lorem ipsum janet',
                                                                       wordcount: 3, sort_order: 0 })
                                                 ]
                                               })
                                  ]
                                }
                              ])

    good_place
  end

  describe 'GET /organizations/:organization_id/grants/:grant_id/reports/:report_id/report_sections' do
    let(:report) do
      good_place_grant = good_place.grants.find { |grant| grant.title == 'Good Place Neighborhood Grant' }
      good_place_grant.reports.first
    end
    let(:params) do
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        report_id: report.id
      }
    end

    it 'renders 401 if unauthenticated' do
      get :index, params: params

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      get :index, params: { **params, organization_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if grant does not exist' do
      set_auth_header(chidi)
      get :index, params: { **params, grant_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if report does not exist' do
      set_auth_header(chidi)
      get :index, params: { **params, report_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not member of organization' do
      shawn = User.find_by!(first_name: 'Shawn')

      set_auth_header(shawn)
      get :index, params: params
      expect(response).to have_http_status(401)
    end

    it "renders 200 with report's sections" do
      section1 = report.report_sections.first
      section2 = report.report_sections.second

      set_auth_header(chidi)
      get :index, params: params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
                                                   a_hash_including(
                                                     'sort_order' => kind_of(Integer),
                                                     'id' => section1.id,
                                                     'created_at' => section1.created_at.iso8601(3),
                                                     'updated_at' => section1.updated_at.iso8601(3),
                                                     'title' => section1.title,
                                                     'text' => section1.text,
                                                     'wordcount' => section1.wordcount
                                                   ),
                                                   a_hash_including(
                                                     'sort_order' => kind_of(Integer),
                                                     'id' => section2.id,
                                                     'created_at' => section2.created_at.iso8601(3),
                                                     'updated_at' => section2.updated_at.iso8601(3),
                                                     'title' => section2.title,
                                                     'text' => section2.text,
                                                     'wordcount' => section2.wordcount
                                                   )
                                                 ])
    end
  end

  describe 'POST /organizations/:organization_id/grants/:grant_id/reports/:report_id/report_sections' do
    let(:new_section_params) do
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        report_id: good_place.grants.first.reports.first.id,
        title: 'New report section',
        text: 'This is a new report section',
        wordcount: 6
      }
    end

    it 'renders 401 if unauthenticated' do
      post :create, params: new_section_params

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      post :create, params: { **new_section_params, organization_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if grant does not exist' do
      set_auth_header(chidi)
      post :create, params: { **new_section_params, grant_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if report does not exist' do
      set_auth_header(chidi)
      post :create, params: { **new_section_params, report_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

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
      expect(JSON.parse(response.body).keys).to contain_exactly(*report_section_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          'id' => kind_of(String),
          'created_at' => kind_of(String),
          'updated_at' => kind_of(String),
          'sort_order' => nil,
          'title' => new_section_params[:title],
          'text' => new_section_params[:text],
          'wordcount' => new_section_params[:wordcount]
        )
      )
    end
  end

  describe 'GET /organizations/:organization_id/grants/:grant_id/reports/:report_id/report_sections/:section_id' do
    let(:section) do
      ReportSection.create!({
                              report: good_place.grants.first.reports.first,
                              title: 'Existing report section',
                              text: 'This is an existing report section',
                              wordcount: 6,
                              sort_order: 0
                            })
    end
    let(:params) do
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        report_id: good_place.grants.first.reports.first.id,
        id: section.id
      }
    end

    it 'renders 401 if unauthenticated' do
      get :show, params: params

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      get :show, params: { **params, organization_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if grant does not exist' do
      set_auth_header(chidi)
      get :show, params: { **params, grant_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if report does not exist' do
      set_auth_header(chidi)
      get :show, params: { **params, report_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if report section does not exist' do
      set_auth_header(chidi)
      get :show, params: { **params, id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if report section is not apart of report' do
      different_section = good_place.grants.second.reports.first.report_sections.first
      set_auth_header(chidi)
      get :show, params: { **params, id: different_section.id }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if not apart of organization' do
      shawn = User.find_by!(first_name: 'Shawn')
      set_auth_header(shawn)

      get :show, params: params
      expect(response).to have_http_status(401)

      get :show, params: { **params, organization_id: shawn.organizations.first.id }
      expect(response).to have_http_status(401)
    end

    it 'renders 200 with report section' do
      set_auth_header(chidi)
      get :show, params: params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*report_section_fields)
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

  describe 'PATCH /organizations/:organization_id/grants/:grant_id/reports/:report_id/report_sections/:section_id' do
    let(:section) do
      ReportSection.create!({
                              report: good_place.grants.first.reports.first,
                              title: 'Existing report section',
                              text: 'This is an existing report section',
                              wordcount: 6,
                              sort_order: 0
                            })
    end
    let(:update_section_params) do
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        report_id: good_place.grants.first.reports.first.id,
        id: section.id,
        title: 'Updated report section',
        text: 'This is the newly updated report section',
        wordcount: 7,
        archived: true
      }
    end

    it 'renders 401 if unauthenticated' do
      patch :update, params: update_section_params

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      patch :update, params: { **update_section_params, organization_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if grant does not exist' do
      set_auth_header(chidi)
      patch :update, params: { **update_section_params, grant_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if report does not exist' do
      set_auth_header(chidi)
      patch :update, params: { **update_section_params, report_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if report section does not exist' do
      set_auth_header(chidi)
      patch :update, params: { **update_section_params, id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if report is not apart of grant' do
      different_section = good_place.grants.second.reports.first.report_sections.first
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

    it 'renders 200 with updated report section' do
      set_auth_header(chidi)
      patch :update, params: update_section_params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*report_section_fields)
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

  describe 'DELETE /organizations/:organization_id/grants/:grant_id/reports/:report_id/report_sections/:section_id' do
    let(:section) do
      ReportSection.create!({
                              report: good_place.grants.first.reports.first,
                              title: 'Existing report section',
                              text: 'This is an existing report section',
                              wordcount: 6,
                              sort_order: 0
                            })
    end
    let(:delete_section_params) do
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        report_id: good_place.grants.first.reports.first.id,
        id: section.id
      }
    end

    it 'renders 401 if unauthenticated' do
      delete :destroy, params: delete_section_params

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if organization does not exist' do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_section_params, organization_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if grant does not exist' do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_section_params, grant_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if report does not exist' do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_section_params, report_id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if report section does not exist' do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_section_params, id: '2d13a7b2-7fc4-418e-b79f-1b6e31fe53a1' }

      expect(response).to have_http_status(401)
    end

    it 'renders 401 if section is not apart of report' do
      different_section = good_place.grants.second.reports.first.report_sections.first
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

    it 'renders 200 with deleted report section' do
      set_auth_header(chidi)
      delete :destroy, params: delete_section_params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*report_section_fields)
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
