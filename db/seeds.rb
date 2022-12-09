# frozen_string_literal: true

require 'securerandom'
require_relative './factories/grant_factory'

unless ENV['RAILS_ENV'] == 'production'
  puts 'Clearing out data...'

  Category.delete_all
  Section.delete_all
  Boilerplate.delete_all
  ReportSection.delete_all
  Report.delete_all
  FundingOrg.delete_all
  Grant.delete_all
  OrganizationUser.delete_all
  Organization.delete_all
  User.delete_all

  puts "Data cleared!\n"
end

unless ENV['RAILS_ENV'] == 'test'
  Dir[File.join(Rails.root, 'db/seeds/**/*.rb')].sort.each do |seed|
    load seed
  end

  puts 'All data seed!'
end
