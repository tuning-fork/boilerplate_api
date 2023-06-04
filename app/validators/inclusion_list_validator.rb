# frozen_string_literal: true

class InclusionListValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, array)
    allowed_values = options[:in]
    array.each do |value|
      record.errors.add(attribute, "'#{value}' is not allowed in list") unless allowed_values.include?(value)
    end
  end
end
