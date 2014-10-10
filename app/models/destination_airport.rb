class DestinationAirport < Airport
  has_many :flights
  has_many :carriers, through: :flights
end
