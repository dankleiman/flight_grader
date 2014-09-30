class Carrier < ActiveRecord::Base
  validates :code, presence: true

end
