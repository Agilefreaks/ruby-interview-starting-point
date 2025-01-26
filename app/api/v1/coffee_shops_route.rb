# frozen_string_literal: true

module Api
  module V1
    class CoffeeShopsRoute < BaseRoute
      route do |r|
        r.get do
          csv_url = ENV.fetch('COFFEE_SHOPS_CSV_URL', 'https://raw.githubusercontent.com/Agilefreaks/test_oop/master/coffee_shops.csv')
          user_coordinates = permit_params(r.params, %w[x y]).transform_keys(&:to_sym)
          csv_data = Services::FetchCsvService.new(csv_url).call
          coffee_shops = Services::ParseCsvService.new(csv_data).call
          coffee_shop_service = Services::CoffeeShopService.new(user_coordinates, coffee_shops)
          closest_shops = coffee_shop_service.call

          closest_shops.map do |shop|
            {
              name: shop[:name],
              distance: shop[:distance]
            }
          end
        end
      end
    end
  end
end
