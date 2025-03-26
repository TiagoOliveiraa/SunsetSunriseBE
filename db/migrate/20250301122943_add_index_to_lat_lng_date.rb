class AddIndexToLatLngDate < ActiveRecord::Migration[8.0]
  def change
    add_index :sun_times, [:lat, :lng, :date], unique: true, name: "index_sun_times_on_lat_lng_date"
  end
end
