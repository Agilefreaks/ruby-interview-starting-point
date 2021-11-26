require 'spec_helper'
require_relative '../lib/distance_calculator'

RSpec.describe DistanceCalculator, method: :call do

  let(:lat1) { 47.6 }
  let(:lat2) { -122.42 }
  let(:lon1) { 47.5869 }
  let(:lon2) { -122.3368 }
  let(:instance) { DistanceCalculator.new(lat1, lat2, lon1, lon2) }

  subject(:distance_in_km) { instance.call }

  it 'returns distance in km between the coordinates' do

    expect(distance_in_km).to eq 6.4068

  end

end
