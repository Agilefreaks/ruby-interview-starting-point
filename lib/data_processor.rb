require 'open-uri'
require 'csv'

class DataProcessor

  def initialize(user_x, user_y, url)
    @user_x = Float(user_x)
    @user_y = Float(user_y)
    @url = URI.parse(url)

  rescue => ex
    puts "Invalid arguments: #{ex.message}"
  end


  def process_data
    raise '`user_x` must be a valid coordinate' unless @user_x.between?(-90, 90)
    raise '`user_y` must be a valid coordinate' unless @user_y.between?(-180, 180)


    # read file data
    file_obj = @url.open { |f| f.read }
    shop_data = CSV.parse(file_obj)


    # get closest shops
    closest_shops = shop_data.map{ |col| { name: col[0],
                                           shop_x: col[1],
                                           shop_y: col[2],
                                           distance: distance_in_km(@user_x, @user_y, Float(col[1]), Float(col[2])) } }

    closest_shops.sort_by! { |k| Float(k[:distance]) }


    # print results
    puts 'These are the three closest coffee shops we found:'
    closest_shops.take(3).each do |shop|
      puts "#{shop[:name]} is #{shop[:distance]} km away"
    end

  rescue => ex
    puts "Failed processing data: #{ex.message}"
  end



  private def distance_in_km(lat1, lon1, lat2, lon2)
    earth_radius = 6371
    rad_per_deg = Math::PI/180

    lat_rad = rad_per_deg * (lat2 - lat1)
    lon_rad = rad_per_deg * (lon2 - lon1)

    lat1_rad = rad_per_deg * lat1
    lat2_rad = rad_per_deg * lat2

    a = Math.sin(lat_rad/2)**2 + Math.sin(lon_rad/2)**2 * Math.cos(lat1_rad) * Math.cos(lat2_rad)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))

    distance = earth_radius * c

    return '%.4f' % distance
  end


end
