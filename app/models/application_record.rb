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
    text_block_array = self.select_stuff(block).keys[0]
    text_score = text_block_array[0].split(" ").length
    text_score
  end 

end
