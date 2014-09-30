require 'csv'

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

end
