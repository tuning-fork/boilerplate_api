# frozen_string_literal: true

require 'rails_helper'

describe OrganizationUser, type: :model do
  describe 'validations' do
    describe 'roles' do
      it 'raises validation error when roles contains invalid role' do
        organization = create(:organization)
        user = create(:user)
        organization_user = OrganizationUser.new(
          organization: organization,
          user: user,
          roles: ['whoopsie', 'oh no']
        )
        expect(organization_user).to_not be_valid
        expect(organization_user.errors.messages[:roles]).to eq([
                                                                  "'whoopsie' is not allowed in list",
                                                                  "'oh no' is not allowed in list"
                                                                ])
      end
    end
  end

  describe 'callbacks' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }

    context 'when role is not set' do
      subject do
        OrganizationUser.new(organization: organization, user: user)
      end

      it 'defaults role to user' do
        expect(subject.roles).to eq([Organization::Roles::USER])
      end
    end

    context 'when role is set' do
      subject do
        OrganizationUser.new(organization: organization, user: user, roles: [Organization::Roles::ADMIN])
      end

      it 'keeps role set' do
        expect(subject.roles).to eq([Organization::Roles::ADMIN])
      end
    end
  end
end
