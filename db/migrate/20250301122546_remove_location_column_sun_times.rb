class RemoveLocationColumnSunTimes < ActiveRecord::Migration[8.0]
  def change
    remove_column :sun_times, :location 
  end
end
