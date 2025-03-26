class LocationCoord < ApplicationRecord
    validates :lat, :lng, :name, presence: true
    validates :name, uniqueness: {scope: [:lat, :lng], message: "Data already exists for this location"}
end
