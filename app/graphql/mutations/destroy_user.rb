class Mutations::DestroyUser < Mutations::BaseMutation
    argument :id, Integer, required: true
  
    field :user, Types::UserType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:)
        user = User.find(id)
        user.destroy
    end
end
