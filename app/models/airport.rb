class Airport < ActiveRecord::Base
  validates :code, presence: true

end
