class AddLatLngColumnsSunTimes < ActiveRecord::Migration[8.0]
  def change
    add_column :sun_times, :lat, :decimal, precision: 10, scale: 6
    add_column :sun_times, :lng, :decimal, precision: 10, scale: 6
  end
end
