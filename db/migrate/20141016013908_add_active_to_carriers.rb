class AddActiveToCarriers < ActiveRecord::Migration
   def up
    add_column :carriers, :active, :boolean

    # set active status for each carrier
    Carrier.all.each do |carrier|
      carrier.update_attributes(active: true) if carrier.flights.any?
    end
  end

  def down
    remove_column :carriers, :active
  end
end
