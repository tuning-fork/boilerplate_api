# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe 'validations' do
    describe 'first_name' do
      it 'must exist' do
        invitation = Invitation.new
        expect(invitation).to be_invalid
        expect(invitation.errors[:first_name]).to include("can't be blank")
      end

      it 'must be at least 2 characters' do
        invitation = Invitation.new(first_name: 'J')
        expect(invitation).to be_invalid
        expect(invitation.errors[:first_name]).to include(/is too short/)
      end
    end

    describe 'last_name' do
      it 'must exist' do
        invitation = Invitation.new
        expect(invitation).to be_invalid
        expect(invitation.errors[:last_name]).to include("can't be blank")
      end

      it 'must be at least 2 characters' do
        invitation = Invitation.new(last_name: 'J')
        expect(invitation).to be_invalid
        expect(invitation.errors[:last_name]).to include(/is too short/)
      end
    end

    describe 'email' do
      it 'must exist' do
        invitation = Invitation.new
        expect(invitation).to be_invalid
        expect(invitation.errors[:email]).to include("can't be blank")
      end

      it 'must be unique at organization level' do
        existing_invitation = create(:invitation, email: 'j@j.j')
        invitation = Invitation.new(email: 'j@j.j', organization_id: existing_invitation.organization_id)
        expect(invitation).to be_invalid
        expect(invitation.errors[:email]).to include(/has already been taken/)
      end

      it 'can be non-unique across organizations' do
        create(:invitation, email: 'j@j.j')
        invitation = Invitation.new(email: 'j@j.j', organization_id: create(:organization).id)
        expect(invitation.errors[:email]).to be_empty

        # Make sure database level constraint allows the email across different orgs
        expect { create(:invitation, email: 'j@j.j') }.not_to raise_error
      end
    end
  end

  describe '#build_accept_link' do
    subject { build(:invitation, token: 'abc123') }

    it 'uses token to build a url' do
      protocol = Rails.env.production? ? 'https' : 'http'
      host = ENV.fetch('FRONTEND_ORIGIN')
      params = subject.slice(:token, :first_name, :last_name, :email)

      expect(subject.build_accept_link).to eq("#{protocol}://#{host}/accept_invite?#{params.to_query}")
    end
  end
end
