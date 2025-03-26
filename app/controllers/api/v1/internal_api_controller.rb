
class Api::V1::InternalApiController < ApplicationController
    
    def sun_time
        location = params[:location]
        date_start = params[:date_start].presence || Date.today.to_s
        date_end = params[:date_end].presence || Date.today.to_s
        
        #Request Validations

        if(Date.parse(date_end) - Date.parse(date_start) < 0)
            return render json: {error: "Date End must be after Date Start"}, status: 400
        end

        if !location.present?
            return render json: {error: "Location is required"}, status: 400
        end
        
        if !valid_date(date_start) || !valid_date(date_end)
            return render json: {error: "Invalid date format. Use YYYY-MM-DD"}, status: 400
        end
                
        #Services Request
        coord = LocationCoordFinder.find_or_fetch(location)
        if coord
            response = SunTimeFinder.find_or_fetch(coord,date_start,date_end)
            render json: response
        else
            render json: coord
        end

    end
    private

    def valid_date(date)
        Date.iso8601(date)
        true
    rescue
        false
    end

end