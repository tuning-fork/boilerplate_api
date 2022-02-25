require "rails_helper"

describe Api::SectionsController do
  section_fields = %w(
    id created_at updated_at title text wordcount sort_order
    grant_id
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
        sections: [
          Section.new({ title: "Overview of the Organization", text: "Lorem ipsum overview", sort_order: 0, wordcount: 3 }),
          Section.new({ title: "Program Goals", text: "Lorem ipsum goals", sort_order: 1, wordcount: 3 }),
        ],
      },
      {
        title: "Bad Janet Restorative Justice Initiative Grant",
        funding_org: good_place.funding_orgs.first,
        sections: [
          Section.new({ title: "Leaders of the Program/Project", text: "Janet", sort_order: 0, wordcount: 1 }),
        ],
      },
    ])

    good_place
  }

  describe "GET /organizations/:organization_id/grants/:grant_id/sections" do
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

    it "renders 200 with grant's sections" do
      section1 = good_place.grants.first.sections.first
      section2 = good_place.grants.first.sections.second

      set_auth_header(chidi)
      get :index, params: {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
        a_hash_including(
          "id" => section1.id,
          "created_at" => section1.created_at.iso8601(3),
          "updated_at" => section1.updated_at.iso8601(3),
          "title" => section1.title,
          "text" => section1.text,
          "wordcount" => section1.wordcount,
          "sort_order" => section1.sort_order,
        ),
        a_hash_including(
          "id" => section2.id,
          "created_at" => section2.created_at.iso8601(3),
          "updated_at" => section2.updated_at.iso8601(3),
          "title" => section2.title,
          "text" => section2.text,
          "wordcount" => section2.wordcount,
          "sort_order" => section2.sort_order,
        ),
      ])
    end
  end

  describe "POST /organizations/:organization_id/grants/:grant_id/sections" do
    let(:new_section_params) {
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        title: "New section",
        text: "This is the new section",
        wordcount: 5,
        sort_order: good_place.grants.first.sections.last.sort_order + 1,
      }
    }

    it "renders 401 if unauthenticated" do
      post :create, params: new_section_params

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      post :create, params: { **new_section_params, organization_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if grant does not exist" do
      set_auth_header(chidi)
      post :create, params: { **new_section_params, grant_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")

      set_auth_header(shawn)
      post :create, params: new_section_params

      expect(response).to have_http_status(401)
    end

    it "renders 422 if given invalid or missing params" do
      set_auth_header(chidi)
      post :create, params: {
        **new_section_params,
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

    it "renders 201 with created section" do
      set_auth_header(chidi)
      post :create, params: new_section_params

      # expect(response).to have_http_status(201)
      expect(JSON.parse(response.body).keys).to contain_exactly(*section_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "title" => new_section_params[:title],
          "text" => new_section_params[:text],
          "wordcount" => new_section_params[:wordcount],
          "sort_order" => new_section_params[:sort_order],
        ),
      )
    end
  end

  describe "GET /organizations/:organization_id/grants/:grant_id/sections/:section_id" do
    let(:section) {
      Section.create!({
        grant: good_place.grants.first,
        title: "Existing section",
        text: "This is an existing section to fetch",
        wordcount: 7,
        sort_order: good_place.grants.first.sections.last.sort_order + 1,
      })
    }
    let(:params) {
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        id: section.id,
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

    it "renders 401 if section does not exist" do
      set_auth_header(chidi)
      get :show, params: { **params, id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if section is not apart of grant" do
      different_section = good_place.grants.second.sections.first
      set_auth_header(chidi)
      get :show, params: { **params, id: different_section.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not apart of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)
      get :show, params: params

      expect(response).to have_http_status(401)
    end

    it "renders 200 with organization" do
      set_auth_header(chidi)
      get :show, params: params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*section_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => section.id,
          "created_at" => section.created_at.iso8601(3),
          "updated_at" => section.updated_at.iso8601(3),
          "title" => section.title,
          "text" => section.text,
          "wordcount" => section.wordcount,
          "sort_order" => section.sort_order,
        ),
      )
    end
  end

  describe "PATCH /organizations/:organization_id/grants/:grant_id/sections/:section_id" do
    let(:section) {
      Section.create!({
        grant: good_place.grants.first,
        title: "Existing section",
        text: "This is an existing section to update",
        wordcount: 7,
        sort_order: good_place.grants.first.sections.last.sort_order + 1,
      })
    }
    let(:update_section_params) {
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        id: section.id,
        title: "Updated section title",
        text: "Updated section text",
        wordcount: 3,
      }
    }

    it "renders 401 if unauthenticated" do
      patch :update, params: update_section_params

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      patch :update, params: { **update_section_params, organization_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if grant does not exist" do
      set_auth_header(chidi)
      patch :update, params: { **update_section_params, grant_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if section does not exist" do
      set_auth_header(chidi)
      patch :update, params: { **update_section_params, id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if section is not apart of grant" do
      different_section = good_place.grants.second.sections.first
      set_auth_header(chidi)
      patch :update, params: { **update_section_params, id: different_section.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not apart of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)
      patch :update, params: update_section_params

      expect(response).to have_http_status(401)
    end

    it "renders 422 if given invalid or missing params" do
      set_auth_header(chidi)
      patch :update, params: {
        **update_section_params,
        title: ""
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body).keys).to contain_exactly("errors")
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "errors" => [match(/Title is too short/)],
        ),
      )
    end

    it "renders 200 with updated section" do
      set_auth_header(chidi)
      patch :update, params: update_section_params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*section_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => section.id,
          "created_at" => section.created_at.iso8601(3),
          "sort_order" => section.sort_order,
          "updated_at" => kind_of(String),
          "title" => update_section_params[:title],
          "text" => update_section_params[:text],
          "wordcount" => update_section_params[:wordcount],
        ),
      )
    end
  end

  describe "DELETE /organizations/:organization_id/grants/:grant_id/sections/:section_id" do
    let(:section) {
      Section.create!({
        grant: good_place.grants.first,
        title: "Existing section",
        text: "This is an existing section to delete",
        wordcount: 7,
        sort_order: good_place.grants.first.sections.last.sort_order + 1,
      })
    }
    let(:delete_section_params) {
      {
        organization_id: good_place.id,
        grant_id: good_place.grants.first.id,
        id: section.id,
      }
    }

    it "renders 401 if unauthenticated" do
      delete :destroy, params: delete_section_params

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_section_params, organization_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if grant does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_section_params, grant_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if section does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { **delete_section_params, id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if section is not apart of grant" do
      different_section = good_place.grants.second.sections.first
      set_auth_header(chidi)
      delete :destroy, params: { **delete_section_params, id: different_section.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not apart of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)
      delete :destroy, params: delete_section_params

      expect(response).to have_http_status(401)
    end

    it "renders 200 with deleted section" do
      set_auth_header(chidi)
      delete :destroy, params: delete_section_params

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*section_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => section.id,
          "created_at" => section.created_at.iso8601(3),
          "updated_at" => section.updated_at.iso8601(3),
          "title" => section.title,
          "text" => section.text,
          "wordcount" => section.wordcount,
          "sort_order" => section.sort_order,
        ),
      )
    end
  end
end