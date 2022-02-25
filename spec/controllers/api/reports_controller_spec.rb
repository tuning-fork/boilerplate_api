require "rails_helper"

describe Api::ReportsController do
  report_fields = %w(
    id created_at updated_at title deadline submitted
    grant_id grant report_sections
  )

  before(:example) {
    org = Organization.create!({
      name: "The Bad Place",
      users: [
        User.new({ email: "shawn@bad.place", password: "shawn", first_name: "Shawn" }),
      ],
      funding_orgs: [
        FundingOrg.new({ website: "https://thebadplace.com", name: "The Bad Place" }),
      ],
    })

    org.grants.create!([
      {
        title: "Bad Place Neighborhood Grant",
        funding_org: org.funding_orgs.first,
        reports: [
          Report.new({ title: "Bad Report", deadline: DateTime.now.next_week.utc, submitted: true }),
        ],
      },
    ])

    org
  }

  let(:chidi) {
    User.create!({ email: "chidi@good.place", password: "chidi", first_name: "Chidi", last_name: "Anagonye" })
  }

  let(:good_place) {
    good_place = Organization.create!({
      name: "The Good Place",
      users: [
        chidi,
        User.new({ email: "tahani@good.place", password: "tahani", first_name: "Tahani", last_name: "Al-Jamil" }),
      ],
      funding_orgs: [
        FundingOrg.new({ website: "https://thegoodplace.com", name: "The Good Place" }),
      ],
    })

    good_place.grants.create!([
      {
        title: "Good Place Neighborhood Grant",
        funding_org: good_place.funding_orgs.first,
        reports: [
          Report.new({ title: "Report 1", deadline: DateTime.now.utc, submitted: true }),
          Report.new({ title: "Report 2", deadline: DateTime.now.next_week.utc, submitted: false }),
        ],
      },
      {
        title: "Bad Janet Restorative Justice Initiative Grant",
        funding_org: good_place.funding_orgs.first,
        reports: [
          Report.new({ title: "Janet Report", deadline: DateTime.now.next_week.utc, submitted: true }),
        ],
      },
    ])

    good_place
  }

  describe "GET /organizations/:organization_id/grants/:grant_id/reports" do
    it "renders 401 if unauthenticated" do
      get :index, params: {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      get :index, params: {
        organization_id: "123",
        grant_id: good_place.grants.first.id,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if grant does not exist" do
      set_auth_header(chidi)
      get :index, params: {
        organization_id: good_place.id,
        grant_id: "123",
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")

      set_auth_header(shawn)
      get :index, params: {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 200 with grant's reports" do
      report1 = good_place.grants.first.reports.first
      report2 = good_place.grants.first.reports.second

      set_auth_header(chidi)
      get :index, params: {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
        a_hash_including(
          "id" => report1.id,
          "created_at" => report1.created_at.iso8601(3),
          "updated_at" => report1.updated_at.iso8601(3),
          "deadline" => report1.deadline.iso8601(3),
          "title" => report1.title,
          "submitted" => report1.submitted,
        ),
        a_hash_including(
          "id" => report2.id,
          "created_at" => report2.created_at.iso8601(3),
          "updated_at" => report2.updated_at.iso8601(3),
          "deadline" => report2.deadline.iso8601(3),
          "title" => report2.title,
          "submitted" => report2.submitted,
        ),
      ])
    end
  end

  describe "POST /organizations/:organization_id/grants/:grant_id/reports" do
    let(:new_report_params) {
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        title: "New report",
        deadline: DateTime.now.iso8601(3),
        submitted: true,
      }
    }

    it "renders 401 if unauthenticated" do
      post :create, params: new_report_params

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      post :create, params: { **new_report_params, organization_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if grant does not exist" do
      set_auth_header(chidi)
      post :create, params: { **new_report_params, grant_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")

      set_auth_header(shawn)
      post :create, params: new_report_params

      expect(response).to have_http_status(401)
    end

    it "renders 422 if given invalid or missing params" do
      set_auth_header(chidi)
      post :create, params: {
        **new_report_params,
        title: "",
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body).keys).to contain_exactly("errors")
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "errors" => [match(/Title is too short/)],
        ),
      )
    end

    it "renders 201 with created report" do
      set_auth_header(chidi)
      post :create, params: new_report_params

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body).keys).to contain_exactly(*report_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "title" => new_report_params[:title],
          "deadline" => new_report_params[:deadline],
          "submitted" => new_report_params[:submitted],
        ),
      )
    end
  end

  describe "GET /organizations/:organization_id/grants/:grant_id/reports/:report_id" do
    let(:report) {
      Report.create!({
        grant: good_place.grants.first,
        title: "Existing report",
        deadline: DateTime.now.utc,
        submitted: false,
      })
    }
    let(:params) {
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        id: report.id,
      }
    }

    it "renders 401 if unauthenticated" do
      get :show, params: params

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      get :show, params: { **params, organization_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if grant does not exist" do
      set_auth_header(chidi)
      get :show, params: { **params, grant_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if report does not exist" do
      set_auth_header(chidi)
      get :show, params: { **params, id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if report is not apart of grant" do
      different_report = good_place.grants.second.reports.first
      set_auth_header(chidi)
      get :show, params: { **params, id: different_report.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not apart of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      get :show, params: params
      expect(response).to have_http_status(401)

      get :show, params: { **params, organization_id: shawn.organizations.first.id  }
      expect(response).to have_http_status(401)
    end

    it "renders 200 with organization" do
      set_auth_header(chidi)
      get :show, params: params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*report_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => report.id,
          "created_at" => report.created_at.iso8601(3),
          "updated_at" => report.updated_at.iso8601(3),
          "deadline" => report.deadline.iso8601(3),
          "title" => report.title,
          "submitted" => report.submitted,
        ),
      )
    end
  end

  describe "PATCH /organizations/:organization_id/grants/:grant_id/reports/:report_id" do
    let(:report) {
      Report.create!({
        grant: good_place.grants.first,
        title: "Existing report",
        deadline: DateTime.now.utc,
        submitted: 7,
      })
    }
    let(:update_report_params) {
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        id: report.id,
        title: "Updated report title",
        deadline: DateTime.now.next_week.utc.iso8601(3),
        submitted: true,
      }
    }

    it "renders 401 if unauthenticated" do
      patch :update, params: update_report_params

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      patch :update, params: { **update_report_params, organization_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if grant does not exist" do
      set_auth_header(chidi)
      patch :update, params: { **update_report_params, grant_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if report does not exist" do
      set_auth_header(chidi)
      patch :update, params: { **update_report_params, id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if report is not apart of grant" do
      different_report = good_place.grants.second.reports.first
      set_auth_header(chidi)
      patch :update, params: { **update_report_params, id: different_report.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not apart of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      patch :update, params: update_report_params
      expect(response).to have_http_status(401)

      patch :update, params: { **update_report_params, organization_id: shawn.organizations.first.id  }
      expect(response).to have_http_status(401)
    end

    it "renders 422 if given invalid or missing params" do
      set_auth_header(chidi)
      patch :update, params: {
        **update_report_params,
        title: "",
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body).keys).to contain_exactly("errors")
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "errors" => [match(/Title is too short/)],
        ),
      )
    end

    it "renders 200 with updated report" do
      set_auth_header(chidi)
      patch :update, params: update_report_params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*report_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => report.id,
          "created_at" => report.created_at.iso8601(3),
          "updated_at" => kind_of(String),
          "title" => update_report_params[:title],
          "deadline" => update_report_params[:deadline],
          "submitted" => update_report_params[:submitted],
        ),
      )
    end
  end

  describe "DELETE /organizations/:organization_id/grants/:grant_id/reports/:report_id" do
    let(:report) {
      Report.create!({
        grant: good_place.grants.first,
        title: "Existing report",
        deadline: DateTime.now.next_week.utc,
        submitted: 7,
      })
    }
    let(:delete_report_params) {
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        id: report.id,
      }
    }

    it "renders 401 if unauthenticated" do
      delete :destroy, params: delete_report_params

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_report_params, organization_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if grant does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_report_params, grant_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if report does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_report_params, id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if report is not apart of grant" do
      different_report = good_place.grants.second.reports.first
      set_auth_header(chidi)
      delete :destroy, params: { **delete_report_params, id: different_report.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not apart of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      delete :destroy, params: delete_report_params
      expect(response).to have_http_status(401)

      delete :destroy, params: { **delete_report_params, organization_id: shawn.organizations.first.id  }
      expect(response).to have_http_status(401)
    end

    it "renders 200 with deleted report" do
      set_auth_header(chidi)
      delete :destroy, params: delete_report_params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*report_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => report.id,
          "created_at" => report.created_at.iso8601(3),
          "updated_at" => report.updated_at.iso8601(3),
          "deadline" => report.deadline.iso8601(3),
          "title" => report.title,
          "submitted" => report.submitted,
        ),
      )
    end
  end
end
