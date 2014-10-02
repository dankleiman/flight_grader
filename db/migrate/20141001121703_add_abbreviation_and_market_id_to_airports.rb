class AddAbbreviationAndMarketIdToAirports < ActiveRecord::Migration
   def up
    add_column :airports, :market_id, :integer
    add_column :airports, :abbreviation, :string
  end

  def down
    remove_column :airports, :market_id, :string
    remove_column :airports, :abbreviation, :string
  end
end
