class DistanceCalculator

  EARTH_RADIUS = 6371
  RADIUS_PER_DEGREE = Math::PI/180

  attr_reader :lat1, :lon1, :lat2, :lon2


  def initialize(lat1, lon1, lat2, lon2)
    @lat1 = lat1
    @lon1 = lon1
    @lat2 = lat2
    @lon2 = lon2
  end


  def call
    lat_rad = (lat2 - lat1) * RADIUS_PER_DEGREE
    lon_rad = (lon2 - lon1) * RADIUS_PER_DEGREE

    lat1_rad = lat1 * RADIUS_PER_DEGREE
    lat2_rad = lat2 * RADIUS_PER_DEGREE

    approximation = Math.sin(lat_rad / 2)**2 + Math.sin(lon_rad / 2)**2 * Math.cos(lat1_rad) * Math.cos(lat2_rad)
    cosines = 2 * Math.atan2(Math.sqrt(approximation), Math.sqrt(1 - approximation))

    distance = EARTH_RADIUS * cosines

    return Float('%.4f' % distance)
  end


end
