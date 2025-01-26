# frozen_string_literal: true

module Services
  class CoffeeShopService
    include Helpers::DistanceHelper

    def initialize(user_coords, coffee_shops)
      @user_coords = user_coords
      @coffee_shops = coffee_shops
    end

    def call
      closest_shops(calculate_distances_hash)
    end

    private

    def calculate_distances_hash
      @coffee_shops.map do |shop|
        distance = calculate_euclidean_distance(
          @user_coords[:x], @user_coords[:y],
          shop[:x], shop[:y]
        )
        shop.merge(distance: distance)
      end
    end

    def closest_shops(shops)
      shops.sort_by { |shop| shop[:distance] }.first(3)
    end
  end
end
