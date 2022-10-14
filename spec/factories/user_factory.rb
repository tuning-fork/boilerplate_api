# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    active { true }
    password { Faker::Alphanumeric.alphanumeric(number: 21) }

    trait :with_organization do
      association :organization, factory: :organization
    end
  end
end
