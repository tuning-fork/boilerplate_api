class Mutations::CreateUser < Mutations::BaseMutation
    argument :first_name, String, required: true
    argument :last_name, String, required: true
    argument :email, String, required: true
    argument :password_digest, String, required: true
    argument :active, Boolean, required: true
    argument :password_reset_token, String, required: true
    argument :password_reset_sent_at, Date, required: true
  
    field :user, Types::UserType, null: false
    field :errors, [String], null: false 
  
    def resolve(name:)
      user = User.new(name: name)
          if user.save
        {
          user: user,
          errors: []
        }
      else
        {
          user: nil,
          errors: user.errors.full_messages
        }
      end
    end
end