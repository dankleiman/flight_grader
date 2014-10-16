class AddActiveColumnToAirports < ActiveRecord::Migration
  def up
    add_column :airports, :active, :boolean

    # set active status for each aiport
    Airport.all.each do |airport|
      airport.update_attributes(active: true) if OriginAirport.find(airport).flights.any?
    end
  end

  def down
    remove_column :airports, :active
  end
end
