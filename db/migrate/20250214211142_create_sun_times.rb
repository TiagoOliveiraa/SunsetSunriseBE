class CreateSunTimes < ActiveRecord::Migration[8.0]
  def change
    create_table :sun_times do |t|
      t.string :location
      t.time :sunrise_time
      t.time :sunset_time
      t.time :golden_hour
      t.date :date

      t.timestamps
    end
  end
end
