# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    subdomain { Faker::Company.name.sub(' ', '-').downcase! }

    trait :with_users do
      after :create do |organization|
        create_list :user, 3, organizations: [organization]
      end
    end
  end
end
