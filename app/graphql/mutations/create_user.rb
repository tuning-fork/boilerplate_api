class Mutations::CreateUser < Mutations::BaseMutation
    argument :first_name, String, required: true
    argument :last_name, String, required: true
    argument :email, String, required: true
    argument :password_digest, String, required: true
    argument :active, Boolean, required: true
    argument :password_reset_token, String, required: true
    argument :password_reset_sent_at, String, required: true
  
    field :user, Types::UserType, null: false
    field :errors, [String], null: false 
  
    def resolve(first_name:, last_name:, email:, password_digest:, active:, password_reset_token:, password_reset_sent_at:)
      user = User.new(first_name: first_name, last_name: last_name, email: email, password_digest: password_digest, active: active, password_reset_token: password_reset_token, password_reset_sent_at: password_reset_sent_at)
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