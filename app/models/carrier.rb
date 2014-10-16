class Carrier < ActiveRecord::Base
  validates :code, presence: true
  has_many :flights
  has_many :airports, through: :flights, source: :origin_airport

  def self.active
    Carrier.where(active: true)
  end

  def delayed_flight_ids
    Delay.where(flight_id: self.flights).map {|delay| delay.flight_id}
  end

  def on_time_percentage
    total_flights = self.flights.count
    total_flights > 0 ? (total_flights - delayed_flight_ids.count) * 100 / total_flights : 0
  end

  def average_delay
    Delay.where(flight_id: self.flights).average('duration').to_i
  end

  def departs_from
    self.airports.uniq
  end
end
