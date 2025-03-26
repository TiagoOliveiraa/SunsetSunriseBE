class AddTimezoneToSunTimes < ActiveRecord::Migration[8.0]
  def change
    add_column :sun_times, :timezone, :string
  end
end
