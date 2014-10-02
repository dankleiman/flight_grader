class CreateDelayCauses < ActiveRecord::Migration
  def change
    create_table :delay_causes do |t|
      t.string :cause

      t.timestamps
    end
  end
end
