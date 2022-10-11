# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_10_10_190549) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "boilerplates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.integer "wordcount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "archived", default: false
    t.uuid "organization_id"
    t.uuid "category_id"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "archived", default: false
    t.uuid "organization_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "email"
    t.string "organization_name"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "funding_orgs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "website"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "archived", default: false
    t.uuid "organization_id"
  end

  create_table "grants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "rfp_url"
    t.datetime "deadline"
    t.boolean "submitted", default: false, null: false
    t.boolean "successful", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "purpose"
    t.boolean "archived", default: false, null: false
    t.uuid "organization_id"
    t.uuid "funding_org_id"
  end

  create_table "invitations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "token"
    t.date "expires_at"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.uuid "user_id"
    t.uuid "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email", "organization_id"], name: "index_invitations_on_email_and_organization_id", unique: true
    t.index ["organization_id"], name: "index_invitations_on_organization_id"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "subdomain", default: "", null: false
    t.index ["subdomain"], name: "index_organizations_on_subdomain", unique: true
  end

  create_table "report_sections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.integer "sort_order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "wordcount"
    t.boolean "archived", default: false
    t.uuid "report_id"
  end

  create_table "reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.datetime "deadline"
    t.boolean "submitted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "archived", default: false
    t.uuid "grant_id"
  end

  create_table "sections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.integer "sort_order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "wordcount"
    t.boolean "archived", default: false
    t.uuid "grant_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.boolean "active"
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.bigint "organization_id"
    t.string "roles", default: [], array: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  add_foreign_key "invitations", "organizations"
  add_foreign_key "invitations", "users"
end
