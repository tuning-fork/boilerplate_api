# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :invitation do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    token { Faker::Alphanumeric.alphanumeric(number: 16) }
    expires_at { 1.week.from_now.to_date }
    association :organization, factory: :organization

    trait :with_user do
      association :user, factory: :user
    end
  end
end
