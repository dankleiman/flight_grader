class OriginAirport < Airport
  has_many :flights
  has_many :carriers, through: :flights
end
