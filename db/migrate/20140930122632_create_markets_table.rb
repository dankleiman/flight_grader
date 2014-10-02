class CreateMarketsTable < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.string :code
      t.text :description

      t.timestamps
    end
  end
end
