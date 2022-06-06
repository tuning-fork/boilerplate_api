require "rails_helper"

describe Api::ReportsController do
  report_fields = %w(
    id uuid created_at updated_at title deadline submitted
    grant_id grant_uuid grant report_sections
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

  # tests using id
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
        deadline: DateTime.now.utc.iso8601(3),
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

    it "renders 200 with reports" do
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
        submitted: false,
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
        submitted: true,
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
  
  # tests using uuid
  describe "GET /organizations/:organization_uuid/grants/:grant_uuid/reports" do
    it "renders 401 if unauthenticated" do
      get :index, params: {
        organization_id: good_place.uuid,
        grant_id: good_place.grants.first.uuid,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      get :index, params: {
        organization_id: "f9f9906f-4616-4893-85ae-e14166e78df8",
        grant_id: good_place.grants.first.uuid,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if grant does not exist" do
      set_auth_header(chidi)
      get :index, params: {
        organization_id: good_place.uuid,
        grant_id: "0f5a342b-04c8-44af-9558-df6a38d9a34a",
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")

      set_auth_header(shawn)
      get :index, params: {
        organization_id: good_place.uuid,
        grant_id: good_place.grants.first.uuid,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 200 with grant's reports" do
      report1 = good_place.grants.first.reports.first
      report2 = good_place.grants.first.reports.second

      set_auth_header(chidi)
      get :index, params: {
        organization_id: good_place.uuid,
        grant_id: good_place.grants.first.uuid,
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
        a_hash_including(
          "uuid" => report1.uuid,
          "created_at" => report1.created_at.iso8601(3),
          "updated_at" => report1.updated_at.iso8601(3),
          "deadline" => report1.deadline.iso8601(3),
          "title" => report1.title,
          "submitted" => report1.submitted,
        ),
        a_hash_including(
          "uuid" => report2.uuid,
          "created_at" => report2.created_at.iso8601(3),
          "updated_at" => report2.updated_at.iso8601(3),
          "deadline" => report2.deadline.iso8601(3),
          "title" => report2.title,
          "submitted" => report2.submitted,
        ),
      ])
    end
  end

  xdescribe "POST /organizations/:organization_uuid/grants/:grant_uuid/reports" do
    let(:new_report_params) {
      {
        organization_id: good_place.uuid,
        grant_id: good_place.grants.first.uuid,
        title: "New report",
        deadline: DateTime.now.utc.iso8601(3),
        submitted: true,
      }
    }

    it "renders 401 if unauthenticated" do
      post :create, params: new_report_params

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      post :create, params: { **new_report_params, organization_id: "a1e5c7f7-33ce-42d0-bd9a-7924491474ed" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if grant does not exist" do
      set_auth_header(chidi)
      post :create, params: { **new_report_params, grant_id: "4ac1ab0e-76c9-4995-b8d9-d0f0ace081b7" }

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
          "uuid" => kind_of(String),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "title" => new_report_params[:title],
          "deadline" => new_report_params[:deadline],
          "submitted" => new_report_params[:submitted],
        ),
      )
    end
  end

  xdescribe "GET /organizations/:organization_uuid/grants/:grant_uuid/reports/:report_uuid" do
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
        organization_id: good_place.uuid,
        grant_id: good_place.grants.first.uuid,
        id: report.uuid,
      }
    }

    it "renders 401 if unauthenticated" do
      get :show, params: params

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      get :show, params: { **params, organization_id: "b7e2c147-38d0-4f40-a294-b3fb06213458" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if grant does not exist" do
      set_auth_header(chidi)
      get :show, params: { **params, grant_id: "cb60c9c2-cd3a-4dfb-90b5-7172102fc682" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if report does not exist" do
      set_auth_header(chidi)
      get :show, params: { **params, id: "7fc8fae2-5022-4e8d-9f17-9d9aefb62a17" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if report is not apart of grant" do
      different_report = good_place.grants.second.reports.first
      set_auth_header(chidi)
      get :show, params: { **params, id: different_report.uuid }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not apart of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      get :show, params: params
      expect(response).to have_http_status(401)

      get :show, params: { **params, organization_id: shawn.organizations.first.uuid  }
      expect(response).to have_http_status(401)
    end

    it "renders 200 with reports" do
      set_auth_header(chidi)
      get :show, params: params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*report_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "uuid" => report.uuid,
          "created_at" => report.created_at.iso8601(3),
          "updated_at" => report.updated_at.iso8601(3),
          "deadline" => report.deadline.iso8601(3),
          "title" => report.title,
          "submitted" => report.submitted,
        ),
      )
    end
  end

  xdescribe "PATCH /organizations/:organization_uuid/grants/:grant_uuid/reports/:report_uuid" do
    let(:report) {
      Report.create!({
        grant: good_place.grants.first,
        title: "Existing report",
        deadline: DateTime.now.utc,
        submitted: false,
      })
    }
    let(:update_report_params) {
      {
        organization_id: good_place.uuid,
        grant_id: good_place.grants.first.uuid,
        id: report.uuid,
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
      patch :update, params: { **update_report_params, organization_id: "d4d19fc4-cc08-4e70-83b7-7a4b2fd21fd5" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if grant does not exist" do
      set_auth_header(chidi)
      patch :update, params: { **update_report_params, grant_id: "94ae81c5-23c0-45bd-a5d5-77b02e356172" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if report does not exist" do
      set_auth_header(chidi)
      patch :update, params: { **update_report_params, id: "a565d26b-3a4f-4a3f-a263-7820c7a74553" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if report is not apart of grant" do
      different_report = good_place.grants.second.reports.first
      set_auth_header(chidi)
      patch :update, params: { **update_report_params, id: different_report.uuid }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not apart of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      patch :update, params: update_report_params
      expect(response).to have_http_status(401)

      patch :update, params: { **update_report_params, organization_id: shawn.organizations.first.uuid  }
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
          "uuid" => report.uuid,
          "created_at" => report.created_at.iso8601(3),
          "updated_at" => kind_of(String),
          "title" => update_report_params[:title],
          "deadline" => update_report_params[:deadline],
          "submitted" => update_report_params[:submitted],
        ),
      )
    end
  end

  xdescribe "DELETE /organizations/:organization_uuid/grants/:grant_uuid/reports/:report_uuid" do
    let(:report) {
      Report.create!({
        grant: good_place.grants.first,
        title: "Existing report",
        deadline: DateTime.now.next_week.utc,
        submitted: true,
      })
    }
    let(:delete_report_params) {
      {
        organization_id: good_place.uuid,
        grant_id: good_place.grants.first.uuid,
        id: report.uuid,
      }
    }

    it "renders 401 if unauthenticated" do
      delete :destroy, params: delete_report_params

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_report_params, organization_id: "51b0dc13-d2c8-4583-8013-ca2cb2b9a82e" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if grant does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_report_params, grant_id: "a734916a-9069-459c-bf3c-e45490b3e113" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if report does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_report_params, id: "1462f6db-5277-4ad4-b923-57129c03e008" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if report is not apart of grant" do
      different_report = good_place.grants.second.reports.first
      set_auth_header(chidi)
      delete :destroy, params: { **delete_report_params, id: different_report.uuid }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not apart of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      delete :destroy, params: delete_report_params
      expect(response).to have_http_status(401)

      delete :destroy, params: { **delete_report_params, organization_id: shawn.organizations.first.uuid  }
      expect(response).to have_http_status(401)
    end

    it "renders 200 with deleted report" do
      set_auth_header(chidi)
      delete :destroy, params: delete_report_params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*report_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "uuid" => report.uuid,
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
