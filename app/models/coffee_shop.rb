# frozen_string_literal: true

class CoffeeShop
  class InvalidCoordinatesError < StandardError; end

  attr_reader :name, :latitude, :longitude

  def initialize(name, latitude, longitude)
    @name = validate_name(name)
    @latitude = validate_coordinate(latitude.to_f, -90..90, 'Latitude')
    @longitude = validate_coordinate(longitude.to_f, -180..180, 'Longitude')
  end

  def distance_to(user_lat, user_lon)
    user_lat = validate_coordinate(user_lat.to_f, -90..90, 'User Latitude')
    user_lon = validate_coordinate(user_lon.to_f, -180..180, 'User Longitude')

    Math.sqrt(((user_lat - latitude)**2) + ((user_lon - longitude)**2)).round(4)
  end

  private

  def validate_name(name)
    name = name.to_s.strip
    raise ArgumentError, 'Name cannot be empty' if name.empty?

    name
  end

  def validate_coordinate(coord, range, name)
    raise InvalidCoordinatesError, "#{name} must be a number" unless coord.is_a?(Numeric)
    raise InvalidCoordinatesError, "#{name} out of range" unless range.include?(coord)

    coord
  end
end
