class Airport < ActiveRecord::Base
  belongs_to :market

  validates :code, presence: true

end
