require_relative 'geocoding'

class Location
  attr_accessor :lat, :lng, :full_address

  def initialize(lat: nil, lng: nil, full_address: nil)
    @lat = lat
    @lng = lng
    @full_address = full_address
  end

  def self.from_coordinates(lat, lng)
    full_address = Geocoder.address([lat, lng])
    new(lat: lat, lng: lng, full_address: full_address)
  end

  def self.from_address(full_address)
    lat, lng = Geocoder.coordinates(full_address)
    new(lat: lat, lng: lng, full_address: full_address)
  end

  def get_distance(to)
    Geocoder::Calculations.distance_between([@lat, @lng], [to.lat, to.lng])
  end
end
