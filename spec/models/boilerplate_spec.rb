# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boilerplate, type: :model do
  context 'test category and organization associations on boilerplate model' do
    subject { Boilerplate.create }

    it { should belong_to :category }
    it { should belong_to :organization }
  end
end
