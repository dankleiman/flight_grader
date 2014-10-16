class AddPositionToAirport < ActiveRecord::Migration
  def up
    add_column :airports, :position, :integer

    Airport.active.sort_by { |airport| airport.on_time_departure_percentage}.reverse.each_with_index do |airport, index|
      airport.update_attributes(position: index + 1)
    end
  end

  def down
    remove_column :airports, :position
  end
end
