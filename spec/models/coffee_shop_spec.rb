# frozen_string_literal: true

require_relative '../../app/models/coffee_shop'

RSpec.describe CoffeeShop do
  describe '#initialize' do
    it 'creates a valid coffee shop' do
      shop = CoffeeShop.new('Test Shop', 45.0, -122.0)

      expect(shop.name).to eq('Test Shop')
      expect(shop.latitude).to eq(45.0)
      expect(shop.longitude).to eq(-122.0)
    end

    it 'raises error for invalid coordinates' do
      expect { CoffeeShop.new('Test', 100.0, 0) }.to raise_error(CoffeeShop::InvalidCoordinatesError)
      expect { CoffeeShop.new('Test', 0, 200.0) }.to raise_error(CoffeeShop::InvalidCoordinatesError)
    end

    it 'raises error for empty name' do
      expect { CoffeeShop.new('', 0, 0) }.to raise_error(ArgumentError)
    end
  end

  describe '#distance_to' do
    let(:shop) { CoffeeShop.new('Test', 0.0, 0.0) }

    it 'calculates distance correctly' do
      expect(shop.distance_to(3.0, 4.0)).to eq(5.0)
      expect(shop.distance_to(1.0, 1.0)).to eq(1.4142)
    end

    it 'raises error for invalid user coordinates' do
      expect { shop.distance_to(95.0, 0) }.to raise_error(CoffeeShop::InvalidCoordinatesError)
    end
  end
end
