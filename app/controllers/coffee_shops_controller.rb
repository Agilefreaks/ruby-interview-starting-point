require "net/http"
require "csv"

class CoffeeShopsController < ApplicationController
  def index
    x = params[:x].to_f
    y = params[:y].to_f

    csv_url = "https://static.reasig.ro/interview/coffee_shops_exerceise/coffee_shops.csv"
    uri = URI(csv_url)
    response = Net::HTTP.get(uri)

    shops = []
    CSV.parse(response, headers: false).each do |row|
      next if row.length < 3
      name = row[0]
      shop_x = Float(row[1]) rescue next
      shop_y = Float(row[2]) rescue next
      distance = Math.sqrt((x - shop_x) ** 2 + (y - shop_y) ** 2)
      shops << { name: name, x: shop_x, y: shop_y, distance: distance.round(4) }
    end

    shops.sort_by! { |s| s[:distance] }
    closest = shops.first(3)

    render json: closest
  end
end
