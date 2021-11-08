module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject
  end

  # class UserMutations < Types::MutationType
  #   SignUp = GraphQL::ObjectType.define do
  #       # your SignUp block
  #   end
  # end
end