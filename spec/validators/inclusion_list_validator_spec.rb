# frozen_string_literal: true

require 'rails_helper'

module Test
  ColorsValidatable = Struct.new(:colors) do
    include ActiveModel::Validations
    validates :colors, inclusion_list: %w[red green blue]
  end
end

describe InclusionListValidator, type: :model do
  subject { Test::ColorsValidatable.new([]) }

  context 'when array contains values not in inclusion list' do
    before do
      subject.colors = %w[orange redd silver]
    end

    it 'is invalid' do
      expect(subject).not_to be_valid
      expect(subject.errors[:colors]).to eq([
                                              "'orange' is not allowed in list",
                                              "'redd' is not allowed in list",
                                              "'silver' is not allowed in list"
                                            ])
    end
  end

  context 'when array only contains values in inclusion list' do
    before do
      subject.colors = %w[blue green red]
    end

    it 'is valid' do
      expect(subject).to be_valid
    end
  end
end
