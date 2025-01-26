# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'

RSpec.describe Api::V1::CoffeeShopsRoute do
  include Rack::Test::Methods

  def app
    Api::V1::CoffeeShopsRoute
  end

  let(:csv_url) { 'https://raw.githubusercontent.com/Agilefreaks/test_oop/master/coffee_shops.csv' }
  let(:user_coords) { { x: 47.6, y: -122.4 } }
  let(:expected_response) do
    [
      { distance: 134.7088, name: 'Starbucks Rio De Janeiro' },
      { distance: 136.2776, name: 'Starbucks Sydney' },
      { distance: 178.4328, name: 'Starbucks Moscow' }
    ]
  end

  before do
    WebMock.disable_net_connect!(allow: 'raw.githubusercontent.com')
    allow(ENV).to receive(:fetch).with('COFFEE_SHOPS_CSV_URL', anything).and_return(csv_url)
  end

  it 'responds with an array of closest coffee shops' do
    get '/api/v1/closest_coffee_shops', user_coords
    expect(last_response.status).to eq 200
    response_body = JSON.parse(last_response.body, symbolize_names: true)
    expect(response_body).to eq(expected_response)
  end
end
