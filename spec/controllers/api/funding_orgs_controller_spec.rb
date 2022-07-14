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
      get :index, params: { organization_id: "96524e19-9dc7-4b3d-b1dc-860ff1fe4362" }

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
          "id" => kind_of(String),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "name" => good_place.funding_orgs.first.name,
          "website" => good_place.funding_orgs.first.website,
          "archived" => good_place.funding_orgs.first.archived,
        ),
        a_hash_including(
          "id" => kind_of(String),
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
      get :index, params: { **new_funding_org_fields, organization_id: "78f5fae7-eafe-4a08-9e37-49b1619763e5" }

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
          "id" => kind_of(String),
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
        organization_id: "b453de7a-40d9-43a0-83a0-9b220e2270b0",
        id: good_place.funding_orgs.first.id,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if funding org does not exist" do
      set_auth_header(chidi)
      get :show, params: {
        organization_id: good_place.id,
        id: "d652f895-0454-4ff0-8f4a-55aacadb2ecb",
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
          "id" => kind_of(String),
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
        organization_id: "539aa2a7-6d13-45d0-97fa-db70e1e89607",
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if funding org does not exist" do
      set_auth_header(chidi)
      patch :update, params: {
        **updated_funding_org_fields,
        id: "12939f44-b041-4f0b-b932-249fdaa9cea5",
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
          "id" => kind_of(String),
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
      delete :destroy, params: { organization_id: "08707e9d-3d32-4f7a-b2f3-4b4889849987", id: good_place.funding_orgs.first.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if funding org does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { organization_id: good_place.id, id: "049d85bb-0903-4729-9c92-e9c8d92d86ea" }

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
