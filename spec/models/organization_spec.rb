# frozen_string_literal: true

require 'rails_helper'

describe Organization, type: :model do
  describe '#users' do
    before do
      organization = create(:organization)
      create(:user, organization: organization, first_name: 'Jason', last_name: 'Mendoza')
      create(:user, organization: organization, first_name: 'Chidi', last_name: 'Anagonye')
      create(:user, organization: organization, first_name: 'Chad', last_name: 'Anagonye')
      create(:user, organization: organization, first_name: 'Elenor', last_name: 'Shellstrop')
      create(:user, organization: organization, first_name: 'Cheeky', last_name: 'Anagonye')
    end

    subject { Organization.first }

    it 'returns users ordered by last name & first name' do
      expect(subject.users.pluck(:first_name, :last_name)).to eq([
                                                                   %w[Chad Anagonye],
                                                                   %w[Cheeky Anagonye],
                                                                   %w[Chidi Anagonye],
                                                                   %w[Jason Mendoza],
                                                                   %w[Elenor Shellstrop]
                                                                 ])
    end
  end

  describe '#pending_invitations' do
    subject { create(:organization) }

    before do
      create(:invitation, organization: subject, email: 'jason@thegoodplace.com')
      create(:invitation, :with_user, organization: subject, email: 'chidi@thegoodplace.com')
      create(:invitation, organization: subject, email: 'elenor@thegoodplace.com')
    end

    it 'returns users ordered by last name & first name' do
      expect(subject.pending_invitations.pluck(:email)).to match_array(%w[jason@thegoodplace.com
                                                                          elenor@thegoodplace.com])
    end
  end

  describe '#admins' do
    subject { create(:organization) }
    let(:users) do
      [
        create(:user, organization: subject, roles: [Organization::Roles::ADMIN]),
        create(:user, organization: subject, roles: [Organization::Roles::USER]),
        create(:user, organization: subject, roles: [Organization::Roles::ADMIN]),
        create(:user, organization: subject, roles: [Organization::Roles::USER])
      ]
    end

    it 'returns users with admin role' do
      expect(subject.admins).to match_array([users.first, users.third])
    end
  end

  describe '#add_user_role' do
    let!(:user) { create(:user, first_name: 'Jason') }
    subject { create(:organization, users: [user]) }

    context "when setting user to 'user' role" do
      before do
        subject.add_user_role(user, Organization::Roles::USER)
      end

      it 'adds given role to organization user' do
        organization_user = OrganizationUser.first
        expect(organization_user.roles).to eq([Organization::Roles::USER])
      end
    end

    context "when setting user to 'admin' role" do
      before do
        subject.add_user_role(user, Organization::Roles::ADMIN)
      end

      it 'adds given role to organization user' do
        organization_user = OrganizationUser.first
        expect(organization_user.roles).to eq([Organization::Roles::ADMIN])
      end
    end

    context 'when setting the role for a user not in the organization' do
      it 'raises record not found error' do
        expect do
          another_user = create(:user)
          subject.add_user_role(another_user, Organization::Roles::ADMIN)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when setting invalid role for a user' do
      it 'raises record invalid error' do
        expect do
          subject.add_user_role(user, 'whoopsie')
        end.to raise_error(ActiveRecord::RecordInvalid, /'whoopsie' is not allowed/)
      end
    end
  end
end
