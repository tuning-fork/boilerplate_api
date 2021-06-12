# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Developing

You will need the following installed:
* Ruby 2.6.5
* PostgreSQL 10

Run the following commands:

```bash
# Install dependencies
$ bundler install
# Set credentials. This will open up an editor that you can exit to continue.
$ rm config/credentials.yml.enc && rails credentials:edit
# Create, migrate, and seed database
$ rails db:create db:migrate db:seed
# Start server on port :3000
$ rails s
```
