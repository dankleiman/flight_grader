class Flight < ActiveRecord::Base
  has_many :delays
  has_many :delay_causes, through: :delays
  belongs_to :origin_airport
  belongs_to :destination_airport
  belongs_to :carrier

end
