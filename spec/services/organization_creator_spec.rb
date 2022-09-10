# frozen_string_literal: true

require 'rails_helper'

describe OrganizationCreator do
  subject { OrganizationCreator.new }

  describe '#call!' do
    let(:creator) { create(:user) }
    let(:organization_params) { { name: 'The Good Place' } }
    let!(:result) { subject.call!(organization_params, creator) }

    it 'returns created organization' do
      expect(result).to be_instance_of(Organization)
      expect(result.name).to eq('The Good Place')
    end

    it 'creates an organization using params' do
      expect(Organization.last.name).to eq('The Good Place')
    end

    it 'adds creator to organization users' do
      expect(Organization.last.users).to include(creator)
    end

    it 'sets creator as admin' do
      # TODO: Come back to Multi-tenancy -- https://github.com/influitive/apartment
      created_organization = result
      expect(creator.admin_of_organization?(created_organization)).to be(true)
    end
  end
end
