class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :code
      t.text :description

      t.timestamps
    end
  end
end
