require 'csv'

# rake tasks for updating database info
# rake import:markets CSV_IMPORT="/Users/dankleiman/Desktop/markets.csv"

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
end
