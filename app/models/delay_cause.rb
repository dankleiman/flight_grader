class DelayCause < ActiveRecord::Base
  has_many :delays
  has_many :flights, through: :delays

end
