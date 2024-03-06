# frozen_string_literal: true

require 'spec_helper'
require 'coffee_shop/app'
require 'webmock/rspec'

RSpec.describe CoffeeShop::App do
  def app
    CoffeeShop::App
  end

  describe '#read_coffee_shop_csv' do
    context 'when reading URI and returns data' do
      let(:get_root) { get '/' }
      before do
        stub_request(:get, 'https://raw.githubusercontent.com/Agilefreaks/test_oop/master/coffee_shops.csv')
          .to_return(status: 200, body: 'Coffee_Shop1, 123, 34')
      end

      it 'returns a status code of 200OK' do
        get_root
        expect(last_response.status).to eq 200
      end

      it 'renders the coffee shop name correctly' do
        get_root
        expect(last_response.body).to match(%r{<h3>Coffee_Shop1</h3>})
        expect(last_response.body).to match(%r{<li>Name: Coffee_Shop1</li>})
      end

      it 'renders the coffee shop latitude correctly' do
        get_root
        expect(last_response.body).to match(%r{<li>Latitude: 123.0</li>})
      end

      it 'renders the coffee shop longitude correctly' do
        get_root
        expect(last_response.body).to match(%r{<li>Longitude: 34.0</li>})
      end
    end

    context 'when reading URI and does not return data' do
      let(:get_root) { get '/' }
      before do
        stub_request(:get, 'https://raw.githubusercontent.com/Agilefreaks/test_oop/master/coffee_shops.csv')
          .to_return(status: 200, body: nil)
      end

      it 'returns a status code of 200OK' do
        get_root
        expect(last_response.status).to eq 200
      end
    end
  end

  describe '/search' do
    let(:coffee_shops) do
      # rubocop:disable Layout/LineLength
      "Starbucks Seattle,47.5809,-122.3160\nStarbucks SF,37.5209,-122.3340\nStarbucks Moscow,55.752047,37.595242\nStarbucks Seattle2,47.5869,-122.3368\nStarbucks Rio De Janeiro,-22.923489,-43.234418\nStarbucks Sydney,-33.871843,151.206767"
      # rubocop:enable Layout/LineLength
    end
    before do
      stub_request(:get, 'https://raw.githubusercontent.com/Agilefreaks/test_oop/master/coffee_shops.csv')
        .to_return(status: 200, body: coffee_shops)
    end

    context 'when searching with valid data' do
      before do
        get '/search', latitude: 12, longitude: 56
      end

      it 'returns a status code 200 OK' do
        expect(last_response.status).to eq 200
      end

      it 'renders the data from first coffee shop' do
        expect(last_response.body).to match(%r{<li>Name: Starbucks Moscow</li>})
        expect(last_response.body).to match(%r{<li>Latitude: 55.752047</li>})
        expect(last_response.body).to match(%r{<li>Longitude: 37.595242</li>})
      end

      it 'renders the data from second coffee shop' do
        expect(last_response.body).to match(%r{<li>Name: Starbucks Rio De Janeiro</li>})
        expect(last_response.body).to match(%r{<li>Latitude: -22.923489</li>})
        expect(last_response.body).to match(%r{<li>Longitude: -43.234418</li>})
      end

      it 'renders the data from third coffee shop' do
        expect(last_response.body).to match(%r{<li>Name: Starbucks Sydney</li>})
        expect(last_response.body).to match(%r{<li>Latitude: -33.871843</li>})
        expect(last_response.body).to match(%r{<li>Longitude: 151.206767</li>})
      end
    end

    context 'when searching with no longitude' do
      before do
        get '/search', latitude: 3.4
      end

      it 'returns a status code 400 Bad Request' do
        expect(last_response.status).to eq 400
      end

      it 'returns an error message' do
        expect(last_response.body).to eq('Parameter is required')
      end
    end

    context 'when searching with no latitude' do
      before do
        get '/search', longitude: 123
      end

      it 'returns a status code 400 Bad Request' do
        expect(last_response.status).to eq 400
      end

      it 'returns an error message' do
        expect(last_response.body).to eq('Parameter is required')
      end
    end

    context 'when query params contain characters' do
      before do
        get '/search', longitude: 'abc', latitude: 34
      end

      it 'returns a status code 400 Bad Request' do
        expect(last_response.status).to eq 400
      end

      it 'returns an error message' do
        expect(last_response.body).to eq("'abc' is not a valid Float")
      end
    end

    context 'when longitude is greater than 180' do
      before do
        get '/search', longitude: 181, latitude: 34
      end

      it 'returns a status code 400 Bad Request' do
        expect(last_response.status).to eq 400
      end

      it 'returns an error message' do
        expect(last_response.body).to eq('Parameter cannot be greater than 180')
      end
    end

    context 'when longitude is less than -180' do
      before do
        get '/search', longitude: -181, latitude: 34
      end

      it 'returns a status code 400 Bad Request' do
        expect(last_response.status).to eq 400
      end

      it 'returns an error message' do
        expect(last_response.body).to eq('Parameter cannot be less than -180')
      end
    end

    context 'when latitude is greater than 90' do
      before do
        get '/search', longitude: 34, latitude: 91
      end

      it 'returns a status code 400 Bad Request' do
        expect(last_response.status).to eq 400
      end

      it 'returns an error message' do
        expect(last_response.body).to eq('Parameter cannot be greater than 90')
      end
    end

    context 'when latitude is less than -90' do
      before do
        get '/search', longitude: 34, latitude: -91
      end

      it 'returns a status code 400 Bad Request' do
        expect(last_response.status).to eq 400
      end

      it 'returns an error message' do
        expect(last_response.body).to eq('Parameter cannot be less than -90')
      end
    end
  end
end
