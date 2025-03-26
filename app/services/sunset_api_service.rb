require 'httparty'

class SunsetApiService
    include HTTParty
    base_uri 'https://api.sunrisesunset.io'

    def initialize(lat, lng, date_start, date_end)
        @options = { lat: lat.to_s, lng: lng.to_s, date_start: date_start, date_end: date_end, time_format: "24"}
    end

    def get_sun_data()
        begin
            response = self.class.get("/json",query: @options)

            case response.code
            when 200
                { success: true, data: response }
            when 400
                { success: false, error: "Invalid Location", status: 400 }
            when 404
                { success: false, error: "No data for this location", status: 404 }
            when 500..599
                { success: false, error: "Internal Server Error. Try again later.", status: response.code }
            else
                { success: false, error: "Unexpected Error, try again later.", status: response.code }
            end
    
        rescue SocketError
            { success: false, error: "Connection Error! Verify your internet connection", status: 503 }
        rescue HTTParty::Error => e
            { success: false, error: "HTTParty Error: #{e.message}", status: 500 }
        rescue StandardError => e
            { success: false, error: "General Error: #{e.message}", status: 500 }
        end

    end
end