# frozen_string_literal: true

require_relative '../../app/services/coffee_shop_finder_service'
require_relative '../../app/models/coffee_shop'

RSpec.describe CoffeeShopFinderService do # rubocop:disable RSpec/BlockLength
  let(:finder) { CoffeeShopFinderService.new }

  context '#closest_shops' do # rubocop:disable RSpec/BlockLength
    subject { finder.closest_shops(user_lat, user_lon) }

    let(:user_lat) { 40.7128 }
    let(:user_lon) { -74.0060 }

    let(:shop_same) { CoffeeShop.new('Same Location', user_lat, user_lon) } # 0.0 distance
    let(:shop_near) { CoffeeShop.new('Starbucks Seattle', 47.5869, -122.316) }
    let(:shop_mid) { CoffeeShop.new('Starbucks Moscow', 55.752047, 37.595242) }
    let(:shop_far) { CoffeeShop.new('Starbucks Sydney', -33.871843, 151.206767) }
    let(:all_shops) { [shop_far, shop_near, shop_mid, shop_same] }

    before do
      allow_any_instance_of(CoffeeShopFinderService)
        .to receive(:fetch_and_parse_coffee_shops)
        .and_return(all_shops)
    end

    describe 'limit functionality' do
      it 'returns the specified number of shops' do
        results = finder.closest_shops(user_lat, user_lon, 2)
        expect(results.size).to eq(2)
      end

      it 'returns all shops if limit is greater than the number of shops' do
        results = finder.closest_shops(user_lat, user_lon, 20)
        expect(results.size).to eq(4)
      end
    end

    describe 'normal functionality' do
      it 'returns shops in ascending order' do
        expect(subject).to eq(
          [
            { shop: shop_same, distance: 0.0 },
            { shop: shop_near, distance: 48.7966 },
            { shop: shop_mid, distance: 112.61 }
          ]
        )
      end
    end

    describe 'edge cases' do
      context 'with empty shop list' do
        it 'returns empty array' do
          allow_any_instance_of(CoffeeShopFinderService)
            .to receive(:fetch_and_parse_coffee_shops).and_return([])

          expect(subject).to be_empty
        end
      end

      context 'with identical locations' do
        let(:dupe_shop) { CoffeeShop.new('Dupe', user_lat, user_lon) }

        it 'returns all matching shops' do
          allow_any_instance_of(CoffeeShopFinderService)
            .to receive(:fetch_and_parse_coffee_shops).and_return([shop_same, dupe_shop])

          expect(subject.size).to eq(2)
          expect(subject.map { |r| r[:distance] }).to all(eq(0.0))
        end
      end
    end
  end
end
