class Section < ApplicationRecord
  belongs_to :grant, :dependent_destroy
end
