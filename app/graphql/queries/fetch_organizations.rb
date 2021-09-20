module Queries
    class FetchOrganizations < Queries::BaseQuery
      type [Types::OrganizationType], null: false
  
      def resolve
        Organization.all
      end
    end
  end