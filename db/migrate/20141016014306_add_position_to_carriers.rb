class AddPositionToCarriers < ActiveRecord::Migration
   def up
    add_column :carriers, :position, :integer

    Carrier.active.sort_by { |carrier| carrier.on_time_percentage}.reverse.each_with_index do |carrier, index|
      carrier.update_attributes(position: index + 1)
    end
  end

  def down
    remove_column :carriers, :position
  end
end
