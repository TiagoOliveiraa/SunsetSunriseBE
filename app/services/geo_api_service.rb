class GeoApiService
    base_uri 'https://api.geoapify.com'

    def initialize(location)
        @options = {query: {text: location, format: "json", apiKey: ENV['API_KEY']}}
    end

    def get_coords()
        begin
            response = self.class.get("/v1/geocode/search",@options)

            code = response["results"].present? ? response.code : 400

            case code
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