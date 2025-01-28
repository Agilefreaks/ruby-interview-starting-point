# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require_relative '../services/coffee_shop_finder_service'

class CoffeeShopController < Sinatra::Base
  configure do
    set :protection, except: [:host_authorization]
    set :show_exceptions, false
    set :raise_errors, true
    enable :logging
  end

  before do
    content_type :json
  end

  get '/closest_shops' do
    content_type 'text/plain'
    lat, lon = validate_coordinates!(params)

    shops_with_distances = coffee_shop_finder_service.closest_shops(lat, lon)
    format_response(shops_with_distances, lat, lon)
  rescue StandardError => e
    handle_error(e)
  end

  private

  # Format shops into "Name --> distance <-- (user-lat, user_lon)" strings
  def format_response(shops_with_distances, user_lat, user_lon)
    header = "Coffee shops nearest (#{user_lat}, #{user_lon}) by distance:\n\n"

    header + shops_with_distances.map do |shops_with_distance|
      shop = shops_with_distance[:shop]
      distance = shops_with_distance[:distance]

      "#{distance} <--> #{shop.name}"
    end.join("\n")
  end

  def validate_coordinates!(parameters)
    error!(400, 'Invalid coordinates') unless parameters[:lat] && parameters[:lon]
    error!(400, 'Coordinates must be numeric') unless numeric?(parameters[:lat]) && numeric?(parameters[:lon])

    lat = parameters[:lat].to_f
    lon = parameters[:lon].to_f
    error!(400, 'Invalid coordinates') unless lat.between?(-90, 90) && lon.between?(-180, 180)

    [lat, lon]
  end

  def numeric?(str)
    return false unless str =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/

    Float(str)
  end

  # Handle errors with appropriate HTTP status codes
  def handle_error(error)
    status_code = case error.message
                  when /Invalid CSV/ then 400
                  when /Failed to fetch CSV/ then 502
                  else 500
                  end

    status status_code
    { error: error.message }.to_json
  end

  def error!(code, message)
    halt code, { error: message }.to_json
  end

  def coffee_shop_finder_service
    CoffeeShopFinderService.new
  end
end
