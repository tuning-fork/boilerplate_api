# frozen_string_literal: true

require 'rails_helper'

describe Organization, type: :model do
  describe '#users' do
    before do
      create(:organization, users: [
               create(:user, first_name: 'Jason', last_name: 'Mendoza'),
               create(:user, first_name: 'Chidi', last_name: 'Anagonye'),
               create(:user, first_name: 'Chad', last_name: 'Anagonye'),
               create(:user, first_name: 'Elenor', last_name: 'Shellstrop'),
               create(:user, first_name: 'Cheeky', last_name: 'Anagonye')
             ])
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
end
