class SunTime < ApplicationRecord
    validates :lat, :lng, :date, presence: true
    validates :date, uniqueness: {scope: [:lat, :lng], message: "Data already exists for this date"}
end
