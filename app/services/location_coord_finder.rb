
class LocationCoordFinder

    def self.find_or_fetch(location)

        coord = LocationCoord.find_by(name: location)
        return coord if coord.present?

        translate_location_to_coords(location)

    end


    def self.translate_location_to_coords(location)
        gateway = GeoApiService.new(location)
        response = gateway.get_coords

        if response[:success]
            LocationCoord.create(
                name: location,
                lat: response[:data]["results"][0]["lat"],
                lng: response[:data]["results"][0]["lon"],
            )
        else
            return response
        end
    end
end