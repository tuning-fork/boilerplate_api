module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :email, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :password_digest, String, null: true
    field :active, Boolean, null: true
    field :password_reset_token, String, null: true
    field :password_reset_sent_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end

