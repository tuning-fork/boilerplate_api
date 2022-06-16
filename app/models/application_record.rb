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

  #unused method for validating all (or any specified) values in a form input are strings
  #kept for future reference
  # validates_each :name, :email, :title, :organization_name, :message, allow_blank: true do |record, attribute, value|
  #   unless value.is_a? String
  #       record.errors[attribute] << (options[:message] || "#{value} is not a string")
  #   end
  # end

end
