class Contact < ApplicationRecord
    validates :name, presence: true, length: { minimum: 2 }
    validates :email, presence: true, uniqueness: true
    validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    validates :message, presence: true, length: { minimum: 5 }
    
    validates_each :name, :email, :title, :organization_name, :message, allow_blank: true do |record, attr, value|
        unless value.is_a? String
            record.errors[attribute] << (options[:message] || "#{value} is not a string")
        end
    end
end