class Carrier < ActiveRecord::Base
  validates :code, presence: true
  has_many :flights

end
