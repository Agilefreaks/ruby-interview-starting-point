# frozen_string_literal: true

require 'csv'
require 'httparty'

class CoffeeShopFinderService
  def closest_shops(user_lat, user_lon, limit = 3)
    coffee_shops = fetch_and_parse_coffee_shops

    # Used for faster distance retrieval
    distances = Hash.new { |h, shop| h[shop] = shop.distance_to(user_lat, user_lon) }
    closest_shops = coffee_shops.min_by(limit) { |shop| distances[shop] }

    closest_shops.map { |shop| { shop: shop, distance: distances[shop] } }
  end

  private

  def fetch_and_parse_coffee_shops
    response = fetch_csv
    parse_coffee_shops(response)
  end

  def parse_coffee_shops(response)
    CSV.parse(response.body, headers: true).map do |row|
      validate_csv_row!(row)
      CoffeeShop.new(row['Name'], row['X Coordinate'], row['Y Coordinate'])
    end
  rescue CSV::MalformedCSVError => e
    raise "Malformed CSV: #{e.message}"
  end

  def fetch_csv
    url = ENV['CSV_URL'] || APP_CONFIG[:csv_url]
    response = HTTParty.get(url)
    raise "Failed to fetch CSV: #{response.code}" unless response.success?

    response
  end

  # Validate CSV row structure
  def validate_csv_row!(row)
    missing = %w[Name X Coordinate Y Coordinate].reject { |h| row[h] }
    raise "Invalid CSV headers: #{missing.join(', ')}" if missing.any?
  end
end
