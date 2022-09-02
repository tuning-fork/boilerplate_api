# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }

    trait :with_users do
      after :create do |organization|
        create_list :user, 3, organizations: [organization]
      end
    end
  end
end
