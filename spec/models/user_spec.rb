require "rails_helper"

describe User, type: :model do
  context "test associations" do
    subject {User.create(first_name: "user", email: "user_email")}
    it {should have_many :organizations}
    it {should have_many :organization_users}
    it {should have_secure_password}
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
    it {should validate_length_of(:password).is_at_least(5)}
  end

  context "test forgot and reset password functions" do
    subject {User.create(first_name: "user", email: "user_email", password: "password")}

    describe "#password_reset" do
      it "updates the password value on the user object" do
        subject.password_reset_token = "test_token"
        subject.reset_password("new_password")
        expect(subject.password_reset_token).to eq(nil)
        expect(subject.password).to eq("new_password")
      end
    end

    describe "#password_token_valid?" do
      it "tests whether password token is valid by checking time within one hour" do
        subject.send_password_reset
        expect(subject.password_token_valid?).to be(true)
      end

      it "tests whether an expired reset token will return invalid/false" do
        subject.send_password_reset
        subject.password_reset_sent_at -= 1.hour
        expect(subject.password_token_valid?).to be(false)
      end
    end
  end

  describe "#is_in_organization?" do
    subject {
      User.create!(
        first_name: "user",
        email: "user@test.com",
        password: "password",
        organizations: [
          Organization.new({ name: "Test Org" }),
        ],
      )
    }

    it "returns true when user is in the provided organization" do
      organization_id = subject.organizations.first.id

      expect(subject.is_in_organization?(organization_id)).to be(true)
    end

    it "returns false when user is not in the provided organization" do
      organization_id = Organization.create!({ name: "New Org" }).id

      expect(subject.is_in_organization?(organization_id)).to be(false)
    end

    it "returns true when user is in the provided organization using uuid" do
      organization_uuid = subject.organizations.first.uuid

      expect(subject.is_in_organization?(organization_uuid)).to be(true)
    end

    it "returns false when user is not in the provided organization using uuid" do
      organization_uuid = Organization.create!({ name: "New Org" }).uuid

      expect(subject.is_in_organization?(organization_uuid)).to be(false)
    end
  end
end
