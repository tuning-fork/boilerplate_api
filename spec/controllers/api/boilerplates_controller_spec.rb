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

  describe "GET /organizations/:organization_id/boilerplates" do
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

    it "renders 200 with organization boilerplates" do
      set_auth_header(chidi)
      get :index, params: { organization_id: good_place.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "title" => good_place.boilerplates.first.title,
          "text" => good_place.boilerplates.first.text,
          "wordcount" => good_place.boilerplates.first.wordcount,
          "organization_id" => good_place.id,
          "organization_name" => good_place.name,
          "category_id" => good_place.boilerplates.first.category.id,
          "category_name" => good_place.boilerplates.first.category.name,
          "archived" => good_place.boilerplates.first.archived,
        ),
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "title" => good_place.boilerplates.second.title,
          "text" => good_place.boilerplates.second.text,
          "wordcount" => good_place.boilerplates.second.wordcount,
          "organization_id" => good_place.id,
          "organization_name" => good_place.name,
          "category_id" => good_place.boilerplates.second.category.id,
          "category_name" => good_place.boilerplates.second.category.name,
          "archived" => good_place.boilerplates.second.archived,
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
      get :index, params: { **new_boilerplate_fields, organization_id: "123" }

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
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "organization_id" => good_place.id,
          "organization_name" => good_place.name,
          "category_id" => good_place.boilerplates.first.category.id,
          "category_name" => good_place.boilerplates.first.category.name,
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
        id: good_place.boilerplates.first.id,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      get :show, params: {
        organization_id: "123",
        id: good_place.boilerplates.first.id,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if boilerplate does not exist" do
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
        id: good_place.boilerplates.first.id,
      }
      expect(response).to have_http_status(401)

      get :show, params: {
        organization_id: shawn.organizations.first.id,
        id: good_place.boilerplates.first.id,
      }
      expect(response).to have_http_status(401)
    end

    it "renders 200 with boilerplate" do
      set_auth_header(chidi)
      get :show, params: {
        organization_id: good_place.id,
        id: good_place.boilerplates.first.id,
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*boilerplate_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "title" => good_place.boilerplates.first.title,
          "text" => good_place.boilerplates.first.text,
          "wordcount" => good_place.boilerplates.first.wordcount,
          "archived" => good_place.boilerplates.first.archived,
        ),
      )
    end
  end

  describe "PATCH /organizations/:organization_id/boilerplates/:boilerplate_id" do
    let(:updated_boilerplate_fields) {
      {
        organization_id: good_place.id,
        id: good_place.boilerplates.first.id,
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
        organization_id: "123",
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if boilerplate does not exist" do
      set_auth_header(chidi)
      patch :update, params: {
        **updated_boilerplate_fields,
        id: "123",
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
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "archived" => good_place.boilerplates.first.archived,
          "title" => updated_boilerplate_fields[:title],
          "text" => updated_boilerplate_fields[:text],
          "wordcount" => updated_boilerplate_fields[:wordcount],
        ),
      )
    end
  end

  describe "DELETE /organizations/:organization_id/boilerplates/:boilerplate_id" do
    it "renders 401 if unauthenticated" do
      delete :destroy, params: { organization_id: good_place.id, id: good_place.boilerplates.first.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { organization_id: "123", id: good_place.boilerplates.first.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if boilerplate does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { organization_id: good_place.id, id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      delete :destroy, params: { organization_id: good_place.id, id: good_place.boilerplates.first.id }
      expect(response).to have_http_status(401)

      delete :destroy, params: { organization_id: shawn.organizations.first.id, id: good_place.boilerplates.first.id }
      expect(response).to have_http_status(401)
    end

    it "renders 200 with deleted boilerplate" do
      boilerplate = good_place.boilerplates.first

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
