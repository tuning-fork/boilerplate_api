# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def select_stuff(*attributes)
    json = {}
    attributes.each do |attribute|
      json[attribute] = self[attribute]
    end

    json
  end

  def count_words(*block)
    text_block_array = select_stuff(block).keys[0]
    text_block_array[0].split.length
  end
end
