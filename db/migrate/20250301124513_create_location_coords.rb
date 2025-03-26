class CreateLocationCoords < ActiveRecord::Migration[8.0]
  def change
    create_table :location_coords do |t|
      t.string :name
      t.decimal :lat
      t.decimal :lng

      t.timestamps
    end
  end
end
