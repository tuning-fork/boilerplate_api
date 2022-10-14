# frozen_string_literal: true

class RemoveOrganizationUsersJoinTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :organization_users
    change_table :users, bulk: true do |t|
      t.uuid :organization_id, index: true
      # maybe circle back to rollify
      t.string :roles, array: true, default: []
    end

    # end of pairing report:
    # lots of things are broken
    # * anything that made use of organization users relationship (controllers,
    #   invitations, probably some other stuff)
    #
    # TODO:
    # * do bare minimum to /fix/ organization users relationship (changing
    #   many_to_many to has_many)
    # * fix seeds to support has many now (might not be a lot work actually, but
    #   ordering matters)
    # * run seeds
    # * from here we want to go to config/initializers/apartment.rb and make use
    #   of ~L49
    #   config.tenant_names = -> { Organization.pluck(:subdomain) }
    # * run migrations (which should create a postgres schema for each tenant)
    # * ...maybe some other stuff...
    # * can we now easily use Pundit in :index, :invite, :accept
    #   InvitationsController now that we're in a mulititenant setup
    # * pontificate about how this impacts frontend?
  end
end
