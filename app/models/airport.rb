class Airport < ActiveRecord::Base
  belongs_to :market
  validates :code, presence: true
  has_many :flights, as: :origin_airport
  has_many :flights, as: :destination_airport
  has_many :carriers, through: :flights
  acts_as_list
  attr_accessor :volume

  def self.active
    Airport.where(active: true)
  end

  def departures
    Flight.where(origin_airport_id: self.id)
  end

  def arrivals
    Flight.where(destination_airport_id: self.id)
  end

  def nearby_airports
    nearby_airports = self.market.airports
    if nearby_airports.count < 6
      nearby_airports = self.market.airports + Airport.find(Flight.where(origin_airport_id: self.id).where(distance_group: 1).distinct.collect { |flight| flight.destination_airport_id }).sort_by { |airport| airport.on_time_departure_percentage}.reverse.first(6 - nearby_airports.count)
    end
    nearby_airports.uniq.sort_by { |airport| airport.on_time_departure_percentage}.reverse
  end

  def active?
    departures.any? || arrivals.any?
  end

  def on_time_departure_percentage
    delayed_departure_count = Delay.where(flight_id: departures).count
    on_time_departure_percentage = (departures.count - delayed_departure_count) * 100 / departures.count
  end

  def on_time_arrival_percentage
    delayed_arrival_count = Delay.where(flight_id: arrivals).count
    on_time_arrival_percentage = (arrivals.count - delayed_arrival_count) * 100 / arrivals.count
  end

  def average_departure_delay
   departures.where.not(departure_delay: 0).average('departure_delay').to_i
  end

  def average_arrival_delay
    arrivals.where.not(arrival_delay: 0).average('arrival_delay').to_i
  end

  def volume=(flights)
    case
      when flights > 2000
        'large'
      when (flights <= 2000 && flights > 1000)
        'medium'
      else
        'small'
    end
  end

end
