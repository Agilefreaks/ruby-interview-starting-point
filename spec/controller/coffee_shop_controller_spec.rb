# frozen_string_literal: true

require 'rack/test'
require_relative '../../app/controllers/coffee_shop_controller'
require_relative '../../app/services/coffee_shop_finder_service'

RSpec.describe CoffeeShopController do # rubocop:disable Metrics/BlockLength
  include Rack::Test::Methods

  def app
    @app ||= Rack::Builder.new do
      map '/api' do
        run CoffeeShopController
      end
    end
  end

  before(:all) do
    CoffeeShopController.set :environment, :test
  end

  let(:valid_lat) { 40.7128 }
  let(:valid_lon) { -74.0060 }
  let(:invalid_coord) { 200.0 }

  let(:mock_shops) do
    [
      { shop: double(name: 'Shop A', distance: 0.5), distance: 0.5 },
      { shop: double(name: 'Shop B', distance: 1.2), distance: 1.2 }
    ]
  end

  before do
    allow_any_instance_of(CoffeeShopController)
      .to receive(:format_response) do |_instance, _shops_with_distances, lat, lon|
      "Coffee shops nearest (#{lat}, #{lon}) by distance:\n\n0.5 <--> Shop A\n1.2 <--> Shop B"
    end
  end

  describe 'GET /api/closest_shops' do # rubocop:disable Metrics/BlockLength
    context 'with valid coordinates' do
      before do
        allow(CoffeeShopFinderService).to receive_message_chain(:new, :closest_shops).and_return(mock_shops)
      end

      it 'returns a 200 OK' do
        get '/api/closest_shops', lat: valid_lat, lon: valid_lon
        expect(last_response.status).to eq(200)
        expect(last_response.content_type).to include('text/plain')
        expect(last_response.body).to include('0.5 <--> Shop A')
        expect(last_response.body).to include('1.2 <--> Shop B')
      end
    end

    context 'with invalid coordinates' do
      it 'returns 400 for missing lat' do
        get '/api/closest_shops', lon: valid_lon
        expect(last_response.status).to eq(400)
        expect(JSON.parse(last_response.body)).to include('error' => 'Invalid coordinates')
      end

      it 'returns 400 for non-numeric lat' do
        get '/api/closest_shops', lat: 'abc', lon: valid_lon
        expect(last_response.status).to eq(400)
      end

      it 'returns 400 for out-of-range lat' do
        get '/api/closest_shops', lat: invalid_coord, lon: valid_lon
        expect(last_response.status).to eq(400)
      end
    end

    context 'when service raises errors' do
      it 'returns 502 for CSV fetch failure' do
        allow(CoffeeShopFinderService).to receive_message_chain(:new, :closest_shops)
          .and_raise(StandardError.new('Failed to fetch CSV'))

        get '/api/closest_shops', lat: valid_lat, lon: valid_lon
        expect(last_response.status).to eq(502)
      end

      it 'returns 400 for invalid CSV data' do
        allow(CoffeeShopFinderService).to receive_message_chain(:new, :closest_shops)
          .and_raise(StandardError.new('Invalid CSV'))

        get '/api/closest_shops', lat: valid_lat, lon: valid_lon
        expect(last_response.status).to eq(400)
      end

      it 'returns 500 for unexpected errors' do
        allow(CoffeeShopFinderService).to receive_message_chain(:new, :closest_shops)
          .and_raise(StandardError.new('Unknown error'))

        get '/api/closest_shops', lat: valid_lat, lon: valid_lon
        expect(last_response.status).to eq(500)
      end
    end
  end
end
