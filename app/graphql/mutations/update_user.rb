class Mutations::UpdateUser < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :first_name, String, required: true
    argument :last_name, String, required: true
    argument :email, String, required: true
    argument :password_digest, String, required: true
    argument :active, Boolean, required: true
    argument :password_reset_token, String, required: true
    argument :password_reset_sent_at, Date, required: true
  
    field :user, Types::UserType, null: false
    field :errors, [String], null: false 
  
    def resolve(id:, **attributes)
      user = User.find(id)
        if user
        user.update!(attributes)
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