class Airport < ActiveRecord::Base
  belongs_to :market
  validates :code, presence: true

  def departures
    Flight.where(origin_airport_id: self.id)
  end

  def arrivals
    Flight.where(destination_airport_id: self.id)
  end

  def nearby_airports
    origin_airport_id = self.id
    nearby_airports = self.market.airports - [self]
    if nearby_airports.count < 5
      nearby_airports += Flight.where(origin_airport_id: origin_airport_id).where(distance_group: 1).collect { |flight| flight.destination_airport }.uniq
    end
    nearby_airports.uniq
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

  def most_common_departure_delay
    Delay.where(flight_id: departures).group_by(&:delay_cause).max_by{ |cause, delay| delay.count }.first.cause
  end

  def most_common_arrival_delay
    Delay.where(flight_id: arrivals).group_by(&:delay_cause).max_by{ |cause, delay| delay.count }.first.cause
  end

  def best_on_time_departure
    grouped_delays = Delay.where(flight_id: departures).group_by { |delay| delay.flight.carrier }
    grouped_flights = departures.group_by { |flight| flight.carrier}
  end

  def best_on_time_arrival
  end

end
