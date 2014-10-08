require 'csv'

# rake tasks for updating database info
# rake import:markets CSV_IMPORT="/Users/dankleiman/Desktop/markets.csv"
# example task:
# desc "import flight info"
#   task flights: :environment do
#     file = ENV["CSV_IMPORT"]
#     prep objects
#     CSV.foreach(file, headers: true ) do |row|
#        do something to each row
#     end
#     some output message
#   end
# end

namespace :import do
  desc "import carriers for carrier tables"
  task carriers: :environment do
    file = ENV["CSV_IMPORT"]
    CSV.foreach(file, headers: true ) do |row|
      c = Carrier.find_or_create_by(code: row["Code"])
      c.description = row["Description"]
      c.save!
    end
  end

  desc "import airports for airport tables"
  task airports: :environment do
    file = ENV["CSV_IMPORT"]
    CSV.foreach(file, headers: true ) do |row|
      c = Airport.find_or_create_by(code: row["Code"])
      c.description = row["Description"]
      c.name = row["Description"].split(": ").last
      c.location = row["Description"].split(": ").first
      c.save!
    end
  end

  desc "import markets"
  task markets: :environment do
    file = ENV["CSV_IMPORT"]
    CSV.foreach(file, headers: true ) do |row|
      m = Market.find_or_create_by(code: row["Code"])
      m.description = row["Description"]
      m.save!
    end
  end

  desc "update market data in airports"
  task update_markets: :environment do
    file = ENV["CSV_IMPORT"]
    airport_codes = Airport.all.select { | airport| !airport.market_id.nil? }.map(&:code)
    skipped = 0
    updated = 0
    CSV.foreach(file, headers: true ) do |row|
      if airport_codes.include?(row["ORIGIN_AIRPORT_ID"])
        skipped += 1
        puts "Skipped #{row["ORIGIN_AIRPORT_ID"]}"
      else
        m = Market.find_by(code: row["ORIGIN_CITY_MARKET_ID"])
        a = Airport.find_by(code: row["ORIGIN_AIRPORT_ID"])
        a.abbreviation = row["ORIGIN"]
        a.market_id = m.id
        a.save!
        updated += 1
        airport_codes << row["ORIGIN_AIRPORT_ID"]
        puts "Updated #{row["ORIGIN_AIRPORT_ID"]}"
      end
    end
    puts "Updated records: #{updated}"
    puts "Skipped records: #{skipped}"
  end

  desc "import flight info"
  task flights: :environment do
    file = ENV["CSV_IMPORT"]

    CSV.foreach(file, headers: true ) do |row|
      # new flight record
      f = Flight.new
      f.flight_date = Date.strptime(row["FL_DATE"], '%m/%d/%Y')
      f.carrier_id = Carrier.find_by(code: row["UNIQUE_CARRIER"]).id
      f.origin_airport_id = Airport.find_by(code: row["ORIGIN_AIRPORT_ID"]).id
      f.destination_airport_id = Airport.find_by(code: row["DEST_AIRPORT_ID"]).id
      f.departure_delay = row["DEP_DELAY_NEW"].to_i
      f.arrival_delay = row["ARR_DELAY_NEW"].to_i
      f.cancellation_code = row["CANCELLATION_CODE"] if row["CANCELLED"] == "1"
      f.distance_group = row["DISTANCE_GROUP"]
      f.save!

      current_flight = Flight.last

      puts "Created #{current_flight}"

      # add delays
      if row["CARRIER_DELAY"].to_i > 0
        delay = Delay.new
        delay.flight = current_flight
        delay.delay_cause = DelayCause.find_or_create_by(cause: "carrier")
        delay.duration = row["CARRIER_DELAY"].to_i
        delay.save!
        puts "CREATED NEW CARRIER DELAY: #{delay}"
      end

      if row["WEATHER_DELAY"].to_i > 0
        delay = Delay.new
        delay.flight = current_flight
        delay.delay_cause = DelayCause.find_or_create_by(cause: "weather")
        delay.duration = row["CARRIER_DELAY"].to_i
        delay.save!
        puts "CREATED NEW WEATHER DELAY: #{delay}"
      end

      if row["NAS_DELAY"].to_i > 0
        delay = Delay.new
        delay.flight = current_flight
        delay.delay_cause = DelayCause.find_or_create_by(cause: "nas")
        delay.duration = row["NAS_DELAY"].to_i
        delay.save!
        puts "CREATED NEW NAS DELAY: #{delay}"
      end

      if row["SECURITY_DELAY"].to_i > 0
        delay = Delay.new
        delay.flight = current_flight
        delay.delay_cause = DelayCause.find_or_create_by(cause: "security")
        delay.duration = row["SECURITY_DELAY"].to_i
        delay.save!
        puts "CREATED NEW SECURITY DELAY: #{delay}"
      end

      if row["LATE_AIRCRAFT_DELAY"].to_i > 0
        delay = Delay.new
        delay.flight = current_flight
        delay.delay_cause = DelayCause.find_or_create_by(cause: "late aircraft")
        delay.duration = row["LATE_AIRCRAFT_DELAY"].to_i
        delay.save!
        puts "CREATED NEW LATE AIRCRAFT DELAY: #{delay}"
      end
    end
  end
end
