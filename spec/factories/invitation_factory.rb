# frozen_string_literal: true

FactoryBot.define do
  factory :invitation do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    token { Faker::Alphanumeric.alphanumeric(number: 16) }
    expires_at { 1.week.from_now.to_date }
    association :organization, factory: :organization
  end
end
