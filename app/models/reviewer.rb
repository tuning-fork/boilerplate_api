class Reviewer < ApplicationRecord
  belongs_to :grants
  belongs_to :users
end
