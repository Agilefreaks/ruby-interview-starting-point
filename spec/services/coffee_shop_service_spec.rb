# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Services::CoffeeShopService, method: :call do
  let(:user_coords) { { x: 47.6, y: -122.4 } }
  let(:coffee_shops) do
    [
      { name: 'Starbucks Seattle', x: 47.61, y: -122.33 },
      { name: 'Starbucks SF', x: 37.77, y: -122.42 },
      { name: 'Starbucks Seattle2', x: 47.63, y: -122.4 }
    ]
  end
  let(:instance) { Services::CoffeeShopService.new(user_coords, coffee_shops) }
  subject(:coffe_shop_service) { instance.call }

  it 'responds with an Array of closest coffee shops' do
    expected_coffee_shops_array =
      [
        { name: 'Starbucks Seattle2', x: 47.63, y: -122.4, distance: 0.03 },
        { name: 'Starbucks Seattle', x: 47.61, y: -122.33, distance: 0.0707 },
        { name: 'Starbucks SF', x: 37.77, y: -122.42, distance: 9.83 }
      ]

    expect(coffe_shop_service).to eq expected_coffee_shops_array
  end
end
