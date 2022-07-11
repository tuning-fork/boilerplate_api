require "rails_helper"

describe Api::BoilerplatesController do
  boilerplate_fields = %w(
    id created_at updated_at title text wordcount archived
    organization_id organization_name category_id category_name category organization
  )

  before(:example) {
    org = Organization.create!({
      name: "The Bad Place",
      users: [
        User.new({ email: "shawn@bad.place", password: "shawn", first_name: "Shawn" }),
      ],
      categories: [
        Category.new({ name: "General Purpose" }),
      ],
    })
    org.boilerplates.create!([
      {
        category: org.categories.first,
        title: "Mission",
        text: "Evil boilerplate",
        wordcount: 2,
      },
    ])
  }

  let(:chidi) {
    User.create!({ email: "chidi@good.place", password: "chidi", first_name: "Chidi", last_name: "Anagonye" })
  }

  let(:good_place) {
    org = Organization.create!({
      name: "The Good Place",
      users: [
        chidi,
        User.new({ email: "tahani@good.place", password: "tahani", first_name: "Tahani", last_name: "Al-Jamil" }),
      ],
      categories: [
        Category.new({ name: "General Purpose" }),
        Category.new({ name: "Bad Janet Truth and Reconciliation" }),
      ],
    })

    org.boilerplates.create!([
      {
        category: org.categories.first,
        title: "Mission",
        text: "Good boilerplate",
        wordcount: 2,
      },
      {
        category: org.categories.first,
        title: "Second boilerplate",
        text: "Very Good boilerplate",
        wordcount: 3,
      },
    ])

    org
  }

  let(:boilerplates) { good_place.boilerplates.order(:title) }

  describe "GET /organizations/:organization_id/boilerplates" do
    it "renders 401 if unauthenticated" do
      get :index, params: { organization_id: good_place.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      get :index, params: { organization_id: "ccaeb04c-648c-4307-9296-3ac57433f50c" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")

      set_auth_header(shawn)
      get :index, params: { organization_id: good_place.id }

      expect(response).to have_http_status(401)
    end

    it "renders 200 with organization boilerplates" do
      set_auth_header(chidi)
      get :index, params: { organization_id: good_place.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
        a_hash_including(
          "id" => kind_of(String),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "title" => boilerplates.first.title,
          "text" => boilerplates.first.text,
          "wordcount" => boilerplates.first.wordcount,
          "organization_id" => good_place.id,
          "organization_name" => good_place.name,
          "category_id" => boilerplates.first.category.id,
          "category_name" => boilerplates.first.category.name,
          "archived" => boilerplates.first.archived,
        ),
        a_hash_including(
          "id" => kind_of(String),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "title" => boilerplates.second.title,
          "text" => boilerplates.second.text,
          "wordcount" => boilerplates.second.wordcount,
          "organization_id" => good_place.id,
          "organization_name" => good_place.name,
          "category_id" => boilerplates.second.category.id,
          "category_name" => boilerplates.second.category.name,
          "archived" => boilerplates.second.archived,
        ),
      ])
    end
  end

  describe "POST /organizations/:organization_id/boilerplates" do
    let(:new_boilerplate_fields) {
      {
        organization_id: good_place.id,
        category_id: good_place.categories.first.id,
        text: "This is the boilerplate",
        title: "New boilerplate",
        wordcount: 4,
      }
    }

    it "renders 401 if unauthenticated" do
      post :create, params: new_boilerplate_fields

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      get :index, params: { **new_boilerplate_fields, organization_id: "07226fdd-8fa3-45da-af65-25fb63e5aa73" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")

      set_auth_header(shawn)
      post :create, params: new_boilerplate_fields

      expect(response).to have_http_status(401)
    end

    it "renders 422 if given invalid or missing params" do
      set_auth_header(chidi)
      post :create, params: {
        **new_boilerplate_fields,
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

    it "renders 201 with created boilerplate" do
      set_auth_header(chidi)
      post :create, params: new_boilerplate_fields

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body).keys).to contain_exactly(*boilerplate_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => kind_of(String),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "organization_id" => good_place.id,
          "organization_name" => good_place.name,
          "category_id" => boilerplates.first.category.id,
          "category_name" => boilerplates.first.category.name,
          "text" => new_boilerplate_fields[:text],
          "title" => new_boilerplate_fields[:title],
          "wordcount" => new_boilerplate_fields[:wordcount],
          "archived" => false,
        ),
      )
    end
  end

  describe "GET /organizations/:organization_id/boilerplates/:boilerplate_id" do
    it "renders 401 if unauthenticated" do
      get :show, params: {
        organization_id: good_place.id,
        id: boilerplates.first.id,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      get :show, params: {
        organization_id: "3fa7d05f-2fed-4f2a-a8b8-a8aa19bf093b",
        id: boilerplates.first.id,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if boilerplate does not exist" do
      set_auth_header(chidi)
      get :show, params: {
        organization_id: good_place.id,
        id: "b8635710-6f19-4ed0-a7b7-443fba9647a7",
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      get :show, params: {
        organization_id: good_place.id,
        id: boilerplates.first.id,
      }
      expect(response).to have_http_status(401)

      get :show, params: {
        organization_id: shawn.organizations.first.id,
        id: boilerplates.first.id,
      }
      expect(response).to have_http_status(401)
    end

    it "renders 200 with boilerplate" do
      set_auth_header(chidi)
      get :show, params: {
        organization_id: good_place.id,
        id: boilerplates.first.id,
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*boilerplate_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => kind_of(String),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "title" => boilerplates.first.title,
          "text" => boilerplates.first.text,
          "wordcount" => boilerplates.first.wordcount,
          "archived" => boilerplates.first.archived,
        ),
      )
    end
  end

  describe "PATCH /organizations/:organization_id/boilerplates/:boilerplate_id" do
    let(:updated_boilerplate_fields) {
      {
        organization_id: good_place.id,
        category_id: good_place.categories.second.id,
        id: boilerplates.first.id,
        title: "Updated Bio",
        text: "This is the updated boilerplate",
        wordcount: 5,
      }
    }

    it "renders 401 if unauthenticated" do
      patch :update, params: updated_boilerplate_fields

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      patch :update, params: {
        **updated_boilerplate_fields,
        organization_id: "67e06663-480e-457b-b678-6bfa34e2889c",
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if boilerplate does not exist" do
      set_auth_header(chidi)
      patch :update, params: {
        **updated_boilerplate_fields,
        id: "fc2836fa-8e0a-4ed6-b56b-815e4863de86",
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      patch :update, params: updated_boilerplate_fields
      expect(response).to have_http_status(401)

      patch :update, params: { **updated_boilerplate_fields, organization_id: shawn.organizations.first.id }
      expect(response).to have_http_status(401)
    end

    it "renders 422 if given invalid or missing params" do
      set_auth_header(chidi)
      patch :update, params: {
        **updated_boilerplate_fields,
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

    it "renders 200 with updated boilerplate" do
      set_auth_header(chidi)
      patch :update, params: updated_boilerplate_fields

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*boilerplate_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => kind_of(String),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "archived" => boilerplates.first.archived,
          "title" => updated_boilerplate_fields[:title],
          "text" => updated_boilerplate_fields[:text],
          "wordcount" => updated_boilerplate_fields[:wordcount],
          "category_id" => updated_boilerplate_fields[:category_id],
        ),
      )
    end
  end

  describe "DELETE /organizations/:organization_id/boilerplates/:boilerplate_id" do
    it "renders 401 if unauthenticated" do
      delete :destroy, params: { organization_id: good_place.id, id: boilerplates.first.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { organization_id: "ff623076-9b3a-474e-9ebc-5757cd3b4719", id: boilerplates.first.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if boilerplate does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { organization_id: good_place.id, id: "e80f6820-05c1-43d0-8bbe-28dbe9f978b6" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      delete :destroy, params: { organization_id: good_place.id, id: boilerplates.first.id }
      expect(response).to have_http_status(401)

      delete :destroy, params: { organization_id: shawn.organizations.first.id, id: boilerplates.first.id }
      expect(response).to have_http_status(401)
    end

    it "renders 200 with deleted boilerplate" do
      boilerplate = boilerplates.first

      set_auth_header(chidi)
      delete :destroy, params: { organization_id: good_place.id, id: boilerplate.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => boilerplate.id,
          "created_at" => boilerplate.created_at.iso8601(3),
          "updated_at" => boilerplate.updated_at.iso8601(3),
          "title" => boilerplate.title,
          "text" => boilerplate.text,
          "wordcount" => boilerplate.wordcount,
          "archived" => boilerplate.archived,
        ),
      )
    end
  end
end
