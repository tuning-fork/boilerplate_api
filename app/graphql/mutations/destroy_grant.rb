class Mutations::DestroyGrant < Mutations::BaseMutation
    argument :id, Integer, required: true
  
    field :grant, Types::GrantType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:)
        grant = Grant.find(id)
        grant.destroy
    end
end
