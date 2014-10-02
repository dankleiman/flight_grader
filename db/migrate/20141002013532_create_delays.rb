class CreateDelays < ActiveRecord::Migration
  def change
    create_table :delays do |t|
      t.integer :flight_id
      t.integer :delay_cause_id
      t.integer :duration

      t.timestamps
    end
  end
end
