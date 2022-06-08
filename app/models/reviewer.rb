class Reviewer < ApplicationRecord
  belongs_to :grant
  belongs_to :user
end
 