class Market < ActiveRecord::Base
  has_many :airports

  validates :code, presence: true

end
