
class SunTimeFinder

    def self.find_or_fetch(coord,date_start,date_end)
        sun_time = SunTime.where(lat: coord[:lat], lng: coord[:lng], date: Date.parse(date_start)..Date.parse(date_end))
        nDays = (Date.parse(date_end) - Date.parse(date_start)).to_i + 1
        if sun_time.present? && sun_time.any?
            if sun_time.size < nDays
                available_dates = sun_time.map(&:date)
                fetch_from_api(coord,date_start,date_end,available_dates)
                sun_time = SunTime.where(lat: coord[:lat], lng: coord[:lng], date: Date.parse(date_start)..Date.parse(date_end))
                organize_data(sun_time,coord)
            else
                return organize_data(sun_time,coord)
            end
        else
            fetch_from_api(coord,date_start,date_end,[])
            sun_time = SunTime.where(lat: coord[:lat], lng: coord[:lng], date: Date.parse(date_start)..Date.parse(date_end))
            organize_data(sun_time,coord)
        end



    end

    def self.fetch_from_api(coord, date_start,date_end, available_dates) 
        gateway = SunsetApiService.new(coord[:lat], coord[:lng], date_start, date_end)
        response = gateway.get_sun_data
        response[:data]["results"].each do |item|
            if !(available_dates.include?(Date.parse(item["date"])))
                SunTime.create(
                    lat: coord[:lat],
                    lng: coord[:lng],
                    sunrise_time: item["sunrise"].present? ? Time.parse(item["sunrise"]).strftime("%H:%M:%S") : nil,
                    sunset_time: item["sunset"].present? ? Time.parse(item["sunset"]).strftime("%H:%M:%S") : nil,
                    golden_hour: item["golden_hour"].present? ? Time.parse(item["golden_hour"]).strftime("%H:%M:%S") : nil,
                    timezone: item["timezone"],
                    date: item["date"],
                )
            end
        end
    end

    def self.organize_data(data,coord)
        data.map do |item|
            {
                location: coord[:name],
                sunrise_time: item["sunrise_time"].present? ? Time.parse(item["sunrise_time"].to_s).strftime("%H:%M:%S") : nil,
                sunset_time: item["sunset_time"].present? ? Time.parse(item["sunset_time"].to_s).strftime("%H:%M:%S") : nil,
                golden_hour: item["golden_hour"].present? ? Time.parse(item["golden_hour"].to_s).strftime("%H:%M:%S") : nil,
                timezone: item["timezone"],
                date: item["date"].to_s
            }
        end
    end

end