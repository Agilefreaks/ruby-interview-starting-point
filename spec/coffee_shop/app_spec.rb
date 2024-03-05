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
end
