require 'rails_helper'

RSpec.describe Bio, type: :model do
  context "test create to see if archived is default set to false" do 
    bio = Bio.create
    it 'should be archived' do   #
      expect(bio.archived).to be_falsy  # test code
    end
  end 
  context "test belongs to organization association" do
    organization = Organization.create(name: "banana")
    bio = Bio.create(organization_id: organization.id)
    it 'should belong to an organization' do
      expect(bio.organization.name).to eq("banana")
    end 
  end
end
