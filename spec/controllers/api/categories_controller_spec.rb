require "rails_helper"

describe Api::CategoriesController do
  category_fields = %w(
    id created_at updated_at name archived
    organization organization_id
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
      categories: [
        Category.new({ name: "General Purpose" }),
        Category.new({ name: "Financial Literacy" }),
      ],
    })
  }

  describe "GET /organizations/:organization_id/categories" do
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

    it "renders 200 with organization categories" do
      set_auth_header(chidi)
      get :index, params: { organization_id: good_place.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "name" => good_place.categories.first.name,
          "archived" => good_place.categories.first.archived,
        ),
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "name" => good_place.categories.second.name,
          "archived" => good_place.categories.second.archived,
        ),
      ])
    end
  end

  describe "POST /organizations/:organization_id/categories" do
    let(:new_category_fields) {
      {
        organization_id: good_place.id,
        name: "New category",
      }
    }

    it "renders 401 if unauthenticated" do
      post :create, params: new_category_fields

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      get :index, params: { **new_category_fields, organization_id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")

      set_auth_header(shawn)
      post :create, params: new_category_fields

      expect(response).to have_http_status(401)
    end

    it "renders 422 if given invalid or missing params" do
      set_auth_header(chidi)
      post :create, params: {
        **new_category_fields,
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

    it "renders 201 with created category" do
      set_auth_header(chidi)
      post :create, params: new_category_fields

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body).keys).to contain_exactly(*category_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "name" => new_category_fields[:name],
          "archived" => false,
        ),
      )
    end
  end

  describe "GET /organizations/:organization_id/categories/:category_id" do
    it "renders 401 if unauthenticated" do
      get :show, params: {
        organization_id: good_place.id,
        id: good_place.categories.first.id,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      get :show, params: {
        organization_id: "123",
        id: good_place.categories.first.id,
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if category does not exist" do
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
        id: good_place.categories.first.id,
      }
      expect(response).to have_http_status(401)

      get :show, params: {
        organization_id: shawn.organizations.first.id,
        id: good_place.categories.first.id,
      }
      expect(response).to have_http_status(401)
    end

    it "renders 200 with category" do
      set_auth_header(chidi)
      get :show, params: {
        organization_id: good_place.id,
        id: good_place.categories.first.id,
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*category_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "name" => good_place.categories.first.name,
          "archived" => good_place.categories.first.archived,
        ),
      )
    end
  end

  describe "PATCH /organizations/:organization_id/categories/:category_id" do
    let(:updated_category_fields) {
      {
        organization_id: good_place.id,
        id: good_place.categories.first.id,
        name: "Updated category",
      }
    }

    it "renders 401 if unauthenticated" do
      patch :update, params: updated_category_fields

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      patch :update, params: {
        **updated_category_fields,
        organization_id: "123",
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if category does not exist" do
      set_auth_header(chidi)
      patch :update, params: {
        **updated_category_fields,
        id: "123",
      }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      patch :update, params: updated_category_fields
      expect(response).to have_http_status(401)

      patch :update, params: { **updated_category_fields, organization_id: shawn.organizations.first.id }
      expect(response).to have_http_status(401)
    end

    it "renders 422 if given invalid or missing params" do
      set_auth_header(chidi)
      patch :update, params: {
        **updated_category_fields,
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

    it "renders 200 with updated category" do
      set_auth_header(chidi)
      patch :update, params: updated_category_fields

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to contain_exactly(*category_fields)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => kind_of(Integer),
          "created_at" => kind_of(String),
          "updated_at" => kind_of(String),
          "archived" => good_place.categories.first.archived,
          "name" => updated_category_fields[:name],
        ),
      )
    end
  end

  describe "DELETE /organizations/:organization_id/categories/:category_id" do
    it "renders 401 if unauthenticated" do
      delete :destroy, params: { organization_id: good_place.id, id: good_place.categories.first.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if organization does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { organization_id: "123", id: good_place.categories.first.id }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if category does not exist" do
      set_auth_header(chidi)
      delete :destroy, params: { organization_id: good_place.id, id: "123" }

      expect(response).to have_http_status(401)
    end

    it "renders 401 if not member of organization" do
      shawn = User.find_by!(first_name: "Shawn")
      set_auth_header(shawn)

      delete :destroy, params: { organization_id: good_place.id, id: good_place.categories.first.id }
      expect(response).to have_http_status(401)

      delete :destroy, params: { organization_id: shawn.organizations.first.id, id: good_place.categories.first.id }
      expect(response).to have_http_status(401)
    end

    it "renders 200 with deleted category" do
      category = good_place.categories.first

      set_auth_header(chidi)
      delete :destroy, params: { organization_id: good_place.id, id: category.id }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match(
        a_hash_including(
          "id" => category.id,
          "created_at" => category.created_at.iso8601(3),
          "updated_at" => category.updated_at.iso8601(3),
          "name" => category.name,
          "archived" => category.archived,
        ),
      )
    end
  end
end
