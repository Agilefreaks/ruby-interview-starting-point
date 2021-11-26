require_relative '../lib/csv_parser'
require_relative '../lib/distance_calculator'

class DataProcessor

  attr_reader :user_x, :user_y, :file_url

  def initialize(user_x, user_y, url)
    @user_x = user_x
    @user_y = user_y
    @file_url = url
  end


  def get_closest_shops(max_count)

    setup_variables

    shop_list = CsvParser.new(file_url).get_data

    shop_list.each do |shop|
      distance_in_km = DistanceCalculator.new(user_x, user_y, shop[:shop_x], shop[:shop_y]).call
      shop[:distance] = distance_in_km
    end

    shop_list.sort_by{ |k| k[:distance] }.take(max_count)

  rescue ArgumentError
    puts 'Please provide valid coordinates'

  rescue URI::InvalidURIError
    puts 'Please provide a valid URL'
  end




  private


  def setup_variables
    @user_x = Float(user_x)
    @user_y = Float(user_y)
    @file_url = URI.parse(file_url)

    raise ArgumentError unless user_x.between?(-90, 90) && user_y.between?(-180, 180)
  end

end
