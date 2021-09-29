class Mutations::CreateGrant < Mutations::BaseMutation
    argument :organization_id, Integer, required: true
    argument :title, String, required: true
    argument :funding_org_id, Integer, required: true
    argument :rfp_url, String, required: true
    argument :deadline, GraphQL::Types::DateTimeType, required: true
    # argument :deadline, GraphQL::Types::ISO8601DateTime, required: true
    argument :submitted, Boolean, required: true
    argument :successful, Boolean, required: true
    argument :purpose, String, required: true
    argument :archived, Boolean, required: true

    field :grant, Types::GrantType, null: false
    field :errors, [String], null: false 
  
    def resolve(organization_id:, title:, funding_org_id:, rfp_url:, deadline:, submitted:, successful:, purpose:, archived:)
      grant = Grant.new(organization_id: organization_id, title: title, funding_org_id: funding_org_id, rfp_url: rfp_url, deadline: deadline, submitted: submitted, successful: successful, purpose: purpose, archived: archived)
          if grant.save
        {
          grant: grant,
          errors: []
        }
      else
        {
          grant: nil,
          errors: grant.errors.full_messages
        }
      end
    end
end