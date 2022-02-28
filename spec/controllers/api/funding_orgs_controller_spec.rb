require "rails_helper"

describe Api::FundingOrgsController do
  funding_org_fields = %w(
    id created_at updated_at name website archived
    organization organization_id
  )

  before(:example) {
    org = Organization.create!({
      name: "The Bad Place",
      users: [
        User.new({ email: "shawn@bad.place", password: "shawn", first_name: "Shawn" }),
      ],
      funding_orgs: [
        FundingOrg.new({ name: "The Bad Place", website: "https://thebadplace.com", }),
      ]
    })
  }

  let(:chidi) {
    User.create!({ email: "chidi@good.place", password: "chidi", first_name: "Chidi", last_name: "Anagonye" })
  }

  let(:good_place) {
    Organization.create!({
      name: "The Good Place",
      users: [
        chidi,
        User.new({ email: "tahani@good.place", password: "tahani", first_name: "Tahani", last_name: "Al-Jamil" }),
      ],
      funding_orgs: [
        FundingOrg.new({ name: "Funding org 1", website: "https://fundingorg1.com" }),
        FundingOrg.new({ name: "Funding org 2", website: "https://fundingorg2.com" }),
      ],
    })
  }

  describe "GET /organizations/:organization_id/funding_orgs" do
    it "renders 401 if unauthenticated" do
      get :index, params: { organization_id: good_place.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      get :index, params: { organization_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")

      set_auth_header(shawn)
      get :index, params: { organization_id: good_place.id }

      expect(response).to have_http_status(401)
    end

    it "renders 200 with organization funding orgs" do
      set_auth_header(chidi)
      get :index, params: { organization_id: good_place.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "name" => good_place.funding_orgs.first.name,
          "website" => good_place.funding_orgs.first.website,
          "archived" => good_place.funding_orgs.first.archived,
        ),
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "name" => good_place.funding_orgs.second.name,
          "website" => good_place.funding_orgs.second.website,
          "archived" => good_place.funding_orgs.second.archived,
        ),
      ])
    end
  end

  describe "POST /organizations/:organization_id/funding_orgs" do
    let(:new_funding_org_fields) {
      {
        organization_id: good_place.id,
        name: "New funding_org",
        website: "https://newfunding.org",
      }
    }

    it "renders 401 if unauthenticated" do
      post :create, params: new_funding_org_fields

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      get :index, params: { **new_funding_org_fields, organization_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")

      set_auth_header(shawn)
      post :create, params: new_funding_org_fields

      expect(response).to have_http_status(401)
    end

    it "renders 422 if given invalid or missing params" do
      set_auth_header(chidi)
      post :create, params: {
        **new_funding_org_fields,
        name: "",
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body).keys).to contain_exactly("errors")
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "errors" => [match(/Name is too short/)],
        ),
      )
    end

    it "renders 201 with created funding_org" do
      set_auth_header(chidi)
      post :create, params: new_funding_org_fields

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body).keys).to contain_exactly(*funding_org_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "name" => new_funding_org_fields[:name],
          "website" => new_funding_org_fields[:website],
          "archived" => false,
        ),
      )
    end
  end

  describe "GET /organizations/:organization_id/funding_orgs/:funding_org_id" do
    it "renders 401 if unauthenticated" do
      get :show, params: {
        organization_id: good_place.id,
        id: good_place.funding_orgs.first.id,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      get :show, params: {
        organization_id: "123",
        id: good_place.funding_orgs.first.id,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if funding org does not exist" do
      set_auth_header(chidi)
      get :show, params: {
        organization_id: good_place.id,
        id: "123",
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      get :show, params: {
        organization_id: good_place.id,
        id: good_place.funding_orgs.first.id,
      }
      expect(response).to have_http_status(401)

      get :show, params: {
        organization_id: shawn.organizations.first.id,
        id: good_place.funding_orgs.first.id,
      }
      expect(response).to have_http_status(401)
    end

    it "renders 200 with funding_org" do
      set_auth_header(chidi)
      get :show, params: {
        organization_id: good_place.id,
        id: good_place.funding_orgs.first.id,
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*funding_org_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "name" => good_place.funding_orgs.first.name,
          "website" => good_place.funding_orgs.first.website,
          "archived" => good_place.funding_orgs.first.archived,
        ),
      )
    end
  end

  describe "PATCH /organizations/:organization_id/funding_orgs/:funding_org_id" do
    let(:updated_funding_org_fields) {
      {
        organization_id: good_place.id,
        id: good_place.funding_orgs.first.id,
        name: "Updated funding_org",
        website: "https://updatedwebsite.org"
      }
    }

    it "renders 401 if unauthenticated" do
      patch :update, params: updated_funding_org_fields

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      patch :update, params: {
        **updated_funding_org_fields,
        organization_id: "123",
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if funding org does not exist" do
      set_auth_header(chidi)
      patch :update, params: {
        **updated_funding_org_fields,
        id: "123",
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      patch :update, params: updated_funding_org_fields
      expect(response).to have_http_status(401)

      patch :update, params: { **updated_funding_org_fields, organization_id: shawn.organizations.first.id }
      expect(response).to have_http_status(401)
    end

    it "renders 422 if given invalid or missing params" do
      set_auth_header(chidi)
      patch :update, params: {
        **updated_funding_org_fields,
        name: "",
      }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body).keys).to contain_exactly("errors")
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "errors" => [match(/Name is too short/)],
        ),
      )
    end

    it "renders 200 with updated funding_org" do
      set_auth_header(chidi)
      patch :update, params: updated_funding_org_fields

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*funding_org_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "archived" => good_place.funding_orgs.first.archived,
          "name" => updated_funding_org_fields[:name],
          "website" => updated_funding_org_fields[:website],
        ),
      )
    end
  end

  describe "DELETE /organizations/:organization_id/funding_orgs/:funding_org_id" do
    it "renders 401 if unauthenticated" do
      delete :destroy, params: { organization_id: good_place.id, id: good_place.funding_orgs.first.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { organization_id: "123", id: good_place.funding_orgs.first.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if funding org does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { organization_id: good_place.id, id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      delete :destroy, params: { organization_id: good_place.id, id: good_place.funding_orgs.first.id }
      expect(response).to have_http_status(401)

      delete :destroy, params: { organization_id: shawn.organizations.first.id, id: good_place.funding_orgs.first.id }
      expect(response).to have_http_status(401)
    end

    it "renders 200 with deleted funding_org" do
      funding_org = good_place.funding_orgs.first

      set_auth_header(chidi)
      delete :destroy, params: { organization_id: good_place.id, id: funding_org.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => funding_org.id,
          "created_at" => funding_org.created_at.iso8601(3),
          "updated_at" => funding_org.updated_at.iso8601(3),
          "name" => funding_org.name,
          "website" => funding_org.website,
          "archived" => funding_org.archived,
        ),
      )
    end
  end
end
