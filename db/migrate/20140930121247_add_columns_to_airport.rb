class AddColumnsToAirport < ActiveRecord::Migration
  def up
    add_column :airports, :location, :string
    add_column :airports, :name, :string

    Airport.all.each do |airport|
      updates = airport.description.split(":")
      airport.update_attributes(location: updates.first, name: updates.last)
      airport.save!
    end
  end

  def down
    remove_column :airports, :location, :string
    remove_column :airports, :name, :string
  end
end
