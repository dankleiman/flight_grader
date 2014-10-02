class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.date :flight_date
      t.integer :carrier_id
      t.integer :origin_airport_id
      t.integer :destination_airport_id
      t.string :cancellation_code
      t.integer :departure_delay
      t.integer :arrival_delay
      t.integer :distance_group


      t.timestamps
    end
  end
end
