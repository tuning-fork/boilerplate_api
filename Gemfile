# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3.12'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.19'
gem 'jwt'

gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'debug', '~> 1.6'
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'rubocop', '~> 1.56', require: false
  gem 'rubocop-performance', '~> 1.14', require: false
  gem 'rubocop-rails', '~> 2.15', require: false
  gem 'seed_dump'
  gem 'shoulda-matchers', '~> 4.0'
end

group :test do
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.19'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'guard-rspec', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'http'
gem 'jb'
gem 'rack-cors'

gem 'ranked-model'

gem 'pundit', '~> 2.2'

gem 'honeybadger', '~> 5.3'
